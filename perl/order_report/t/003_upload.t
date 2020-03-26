use strict;
use warnings;

use lib ('./lib');

use IO::File;
use OrderReport::Upload ();
use Test::More;
use Test::Exception;

require_ok('OrderReport::Upload');

throws_ok { OrderReport::Upload->new() } qr/required.*?file_handle/, 'Upload expects a file_handle'; 

my $empty_file = IO::File->new_tmpfile or die "Could not open a temporary file: $!";

ok(OrderReport::Upload->new( file_handle => $empty_file ), 'Upload with empty file is ok');

my @records = OrderReport::Upload->new( file_handle => $empty_file )->process();
is_deeply(\@records, [], 'Processing an empty file yields zero records'); 

my $headers_only = IO::File->new_tmpfile;
$headers_only->print(join ',', qw(these are some headers));
$headers_only->seek(0, 0); 

@records = OrderReport::Upload->new( file_handle => $headers_only )->process();
is_deeply(\@records, [], 'Processing a file with only headers yields zero records'); 

my $one_record = IO::File->new_tmpfile;
$one_record->print(join(',', qw(item_name item_manufacturer item_price)) . "\n" . join(',', ('   foo', 'bar   ', '$0.00'))); 
$one_record->seek(0, 0); 

$one_record->seek(0, 0); 
@records = OrderReport::Upload->new( file_handle => $one_record )->process();
is(scalar @records, 1, 'Processing a file with headers and one line of data yields one record'); 

my $record = shift @records;

ok($record->{item_name} eq 'foo', 'leading whitespace gets trimmed');
ok($record->{item_manufacturer} eq 'bar', 'trailing whitespace gets trimmed');
ok($record->{item_price} eq '0.00', 'dollar sign gets removed from item_price');

done_testing();