package OrderReport;

use common::sense;
use Moops;

class Upload {
    use Dancer2 qw(:syntax);

    use Text::CSV_XS qw(csv);
    use String::Trim qw(trim);

    has 'file_handle' => (
      is 	   => 'ro', 
      isa 	   => 'FileHandle',
      required => true
      );

    method process () {
        my $sanitise_record = fun(Object $csv, HashRef $record) {
            trim($_) for values(%$record);

            # We store the price as REAL - remove dollar sign
            # Price formatting is otherwise part of presentation
            $record->{item_price} =~ s/^\$//;
        };

        return @{ csv(
            in 		  => $self->file_handle,
            headers   => config->{csv}{header_mapping},
            callbacks => {
                after_in => $sanitise_record
            }
        ) || [] };
    }
}

1;