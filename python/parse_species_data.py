#!/usr/bin/env python

"""
    parse_species_data.py - script to display number of unique genera for (a)
    given habitat(s)

    Usage: parse_species_data.py [-m] [-v] <data_file>

    One can run parse_species_data.py -h
        for a list of command-line options.

    Supplied data should be in the format of:
        [habitat_number]: [species,...]
    e.g.:
        12345: Homo sapiens sapiens, Homo habilis, Homo heidelbergensis
        67891: Homo neanderthalensis, Mosasaurus hofmanni

    Limited coverage tests in the bottom of the file. 
    Tested using Nose, python v2.7.6. 
"""

import sys, re, os, argparse

HEADER_COLOR  = "\033[32m"
ERROR_COLOR   = "\033[31m"
WARNING_COLOR = "\033[93m"
END_COLOR     = "\033[0m"

RECORD_REGEX  = re.compile( r"""^
                              (?P<habitat>[0-9]{5,})
                              (?:\s?\:+\s?)
                              (?P<species>(?:(\w+\s\w+)(?:\s?\,?\s?))+)
                            $""", re.VERBOSE )

SPECIES_REGEX = re.compile( r"""
                              (?P<species>
                                  (?P<genus>\w+)
                                  (\s\w+)+)
                            """, re.VERBOSE )


""" Render a non-fatal warning """
def warn(message):
    fatal(message, fatal=False)


def fatal(message, fatal=True):
    """
        Raises a fatal exception (default) or throws a warning.
    """

    if fatal:
        raise RuntimeError("%sError parsing data: %s%s" %
            (ERROR_COLOR, message, END_COLOR))

    sys.stderr.write("%s*** Warning: %s ***%s\n" %
            (WARNING_COLOR, message, END_COLOR))


def _sanitise_record(record):
    CONSECUTIVE_SPACES = re.compile(r"\s{2,}")

    record = record.strip()

    if not record:
        return None

    ### normalise possible multiple spaces 
    record = re.sub(CONSECUTIVE_SPACES, " ", record)

    return record
    

def extract_data_from_record(record):
    """
        Attempt to extract data from a given record using two regular expressions. 
        The first regex checks for a valid data record and extracts the habitat and species list.
        The second regex extracts the full name and genus for each species.
        Any non-parseable record throws a warning.

        Returns: {
            "habitat" : [int],  # 12345
            "species" : [set],  # Homo habilis, Mosasaurus hofmanni
            "genera"  : [set],  # Homo, Mosasaurus
        }
    """
    
    record = _sanitise_record(record)

    if record is None:
        return record

    match = RECORD_REGEX.match(record)

    if match is None:
        warn("Invalid data record: '%s' " \
             "could not parse, skipping." % record)

        return match

    data_dict = match.groupdict()
    habitat   = int(data_dict["habitat"])
    species   = data_dict["species"]

    genus_set   = set()
    species_set = set()

    matches = re.finditer(SPECIES_REGEX, species)

    for match in matches:
        data_dict = match.groupdict()
        genus_set.add(data_dict["genus"])
        species_set.add(data_dict["species"])

    return {
        "habitat" : habitat,
        "species" : species_set,
        "genera"  : genus_set,
    }
    

def parse_file(file_name, merge):
    """
        Initialise a generator that yields a processed record for each
        line of data in the file. 

        Depending on whether we attempt to merge duplicate habitats, either
        the generator itself is returned, or a final processed dictionary
        of habitats, of the format:

        {
            [habitat] : {           # 12345
                "habitat" : [int]   # 12345 - denormalised for rendering later
                "genera"  : [set],  # Homo, Mosasaurus
                "species" : [set],  # Homo habilis, Mosasaurus hofmanni
            } 
            ...
        }
    """

    ### use a generator to save memory in case of huge data files
    ### this only works when we are not merging duplicate habitats
    ### since that requires processing the entire file
    def record_generator(file_name):
        try:
            with open(file_name) as file_handler:
                for line in file_handler:
                    extracted = extract_data_from_record(line)
                    if not extracted:
                        continue
                    yield extracted

        except IOError as file_error:
            fatal(file_error.strerror)

    records = record_generator(file_name)

    if not merge:
        return records

    habitats = {}

    ### merge distinct genera and species by habitat
    for record in records:
        if record["habitat"] in habitats:
            habitat_data = habitats[ record["habitat"] ]
            for key in ["genera", "species"]:
                habitat_data[key].update(record[key])
        else:
            habitats[ record["habitat"] ] = {
                "habitat" : record["habitat"],
                "genera"  : record["genera"],
                "species" : record["species"],
            }
        
    return habitats


def render_parsing_results(habitat_data, verbose, merge):
    """
        Pretty-print the relevant parsing results.    
    """

    def render_header():
        print "%s%-8s %s%s" % (HEADER_COLOR, "HABITAT", "GENERA", END_COLOR)

    def render_record(r):
        if not verbose:
            print "%-8d %d" % (r["habitat"], len(r["genera"]))
            return

        print "%-8d %-6d (%s) - (%s)" % \
            (r["habitat"], 
             len(r["genera"]), 
             ', '.join(sorted(r["genera"])),
             ', '.join(sorted(r["species"])))

    ### no merging, so this is a generator we can process
    if not merge:
        render_header()
        for record in habitat_data:
            render_record(record)

    ### process the pre-merged habitat dict
    ### this also allows us to sort by habitat and
    ### warn the user about possible flawed data beforehand
    else:
        if not habitat_data:
            fatal("No valid data found in file.")

        render_header()
        for habitat in sorted(habitat_data):
            render_record(habitat_data[habitat])


def main():
    """ 
        Parse command-line arguments, parse and render the results.
    """

    parser = argparse.ArgumentParser(
        description = 'Display number of unique genera " \
            for a list of habitats and species.')

    parser.add_argument('file_name',
        metavar = 'FILE',
        type    = str,
        help    = 'a file containing data to process'
    )

    parser.add_argument('-v',
        dest    = 'verbose',
        action  = 'store_true',
        help    = "append the list of genera and species for each habitat"
    )

    parser.add_argument('-m',
        dest   = 'merge',
        action = 'store_true',
        help   = "merge multiple habitat occurrences " \
            "(possibly memory intensive)"
    )

    class ArgumentHolder(object):
        pass

    a = ArgumentHolder()

    parser.parse_args(namespace = a)

    render_parsing_results(
        parse_file(a.file_name, a.merge), 
        a.verbose, a.merge
    )


if __name__ == "__main__": main()


""" __TESTS__ """

import unittest, tempfile

class MockNull(object):
    """
        Mock std* replacement for output capturing.
    """

    def __init__(self):
        self._capture = ''

    def write(self, data):
        self._capture += data


class WarningCapturer(object):
    """
        Simple context manager to suppress and capture
        stderr output.
    """

    def __enter__(self):
        self.old_stderr = sys.stderr
        self.mocknull = MockNull()
        sys.stderr = self.mocknull

    def __exit__(self, type, value, traceback):
        sys.stderr = self.old_stderr


class TestParser(unittest.TestCase):

    def setUp(self):
        try:
            self.temp_file = tempfile.NamedTemporaryFile()
        except Exception as e:
            raise Exception("Unable to create temp file: %s" % e) 

        self.capture_warnings = WarningCapturer()


    def tearDown(self):
        # self.temp_file is closed automatically on GC
        pass


    def test_single_record(self):
        record   = "12345: Homo sapiens, Homo habilis"
        actual   = extract_data_from_record(record)
        expected = {
            "habitat" : 12345,
            "genera"  : set(["Homo"]),
            "species" : set(["Homo sapiens", "Homo habilis"]),
        }
        self.assertEqual(actual, expected, "Single record extracts")


    def test_invalid_data_file(self):
        with self.assertRaises(RuntimeError) as context:
            self.temp_file.write("foo\nbar\naz\n")
            self.temp_file.flush()

            merge      = True
            no_verbose = False

            with self.capture_warnings:
                result = parse_file(self.temp_file.name, merge)

            render_parsing_results(result, no_verbose, merge)

        self.assertEqual(result, {}, "Invalid file begets empty dict")

        self.assertRegexpMatches(context.exception.__str__(), 
            r"No valid data found in file.")


    def test_merge_multi_record_file(self):
        test_records = \
"""12345: Homo habilis, Homo sapiens, Homo erectus

45678: Baryonyx walkeri, Mosasaurus hofmanni
12345: Baryonyx walkeri, Homo sapiens"""

        self.temp_file.write(test_records)
        self.temp_file.flush()

        merge = True

        actual   = parse_file(self.temp_file.name, merge)

        expected = {
            12345 : {
                "habitat" : 12345,
                "genera"  : set(["Homo", "Baryonyx"]),
                "species" : set(["Homo habilis", "Homo sapiens", 
                                 "Homo erectus", "Baryonyx walkeri"]),
            },
            45678 : {
                "habitat" : 45678,
                "genera"  : set(["Baryonyx", "Mosasaurus"]),
                "species" : set(["Baryonyx walkeri", "Mosasaurus hofmanni"]),
            }
        }
        self.assertEqual(actual, expected)


    def test_liberal_parser(self):
        data = [
            {
                "record"   : "12345678: Homo sapiens sapiens, Homo " \
                             "sapiens sapiens, Baryonyx walkeri",
                "expected" : {
                    "habitat" : 12345678,
                    "genera"  : set(["Homo", "Baryonyx"]),
                    "species" : set(["Homo sapiens sapiens", 
                                     "Baryonyx walkeri"])
                }
            },
            {
                "record"   : "12345  ::::     Homo sapiens          sapiens, Baryonyx " \
                             "walkeri",
                "expected" : {
                    "habitat" : 12345,
                    "genera"  : set(["Homo", "Baryonyx"]),
                    "species" : set(["Homo sapiens sapiens", 
                                     "Baryonyx walkeri"])
                }
            },
            {
                
                "record"   : "12345 :  Homo    sapiens  sapiens   , Baryonyx walkeri    ",
                "expected" : {
                    "habitat" : 12345,
                    "genera"  : set(["Homo", "Baryonyx"]),
                    "species" : set(["Homo sapiens sapiens", 
                                     "Baryonyx walkeri"])
                }
            }
        ]

        for case in data:
            actual = extract_data_from_record(case["record"])
            self.assertEqual(actual, case["expected"])


    def test_broken_record(self):
        record = "abcde: Homo sapiens, Homo habilis"
        with self.capture_warnings:
            actual = extract_data_from_record(record)
            captured_warning = self.capture_warnings.mocknull._capture
        expected = None
        self.assertRegexpMatches(captured_warning, r"could not parse, skipping", 
            "Broken record parsing throws warning")
        self.assertEqual(actual, expected, "Broken record results in None")
