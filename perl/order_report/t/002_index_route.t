use strict;
use warnings;

use lib ('./lib');

use OrderReport;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

my $app = OrderReport->to_app;
is( ref $app, 'CODE', 'Application is available' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/' );

ok( $res->is_success, '[GET /] successful' );

$res  = $test->request( GET '/report' );

ok( $res->is_success, '[GET /report] successful' );

$res = $test->request( POST '/upload/order_data' );

ok( $res->is_redirect, '[POST /upload/order_data] without a file was successful');

done_testing();