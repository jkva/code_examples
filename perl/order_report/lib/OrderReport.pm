package OrderReport;

use Dancer2;

use common::sense;

use Try::Tiny;
use OrderReport::Upload;
use OrderReport::DB;

our $VERSION = '0.1';

hook after_template_render => sub {
    debug 'Clearing session upload_message';
    session 'upload_message' => undef;
    debug 'Clearing session new_records';
    session 'new_records' => undef;
};

# Show upload form and report
get '/' => sub {
    template 'index' => {
        orders_exist => OrderReport::DB::contains_orders()
    }
};

get '/report' => sub {
    template 'report' => { 
        orders => OrderReport::DB::get_orders() 
    }
};

# Process uploaded csv file
post '/upload/order_data' => sub {
    my $upload = upload('data_file');

    try {
        my @csv_records = OrderReport::Upload->new(
            file_handle => $upload->file_handle,
            )->process();

        my @db_records = map { OrderReport::DB::insert_order($_) } @csv_records;
        
        my $message = scalar @db_records
            ? 'New order data was successfully uploaded.'
            : 'The file was uploaded successfully, but did not seem to contain order data.'
        ;

        session 'upload_message' => {
            type => 'success',
            message => $message
        };

        session 'new_records' => \@db_records;
    } catch {
        error "Error processing uploaded CSV:" . $_;

        session 'upload_message' => {
            type => 'danger',
            message => 'There was a problem processing the file. Please ensure that you are uploading valid order information.'
        }
    } finally {
        $upload && unlink $upload->filename;
    };

    redirect('/');
};

true;