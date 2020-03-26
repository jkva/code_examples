package OrderReport;

use common::sense;
use Moops;

class DB {
    use Dancer2 qw(:syntax);
    use Dancer2::Plugin::DBIC qw(resultset);
    use List::Util qw(reduce);

    fun contains_orders () {
        return resultset('Order')->count() > 0;    
    }

    # Generate an AoH of orders and their purchases
    fun get_orders () {
        my @orders = resultset('Order')->search(
            undef,
            { order_by => { -desc => [qw(orderdate ordernumber)] } }
        );

        my @sort_order;
        
        my $orders = reduce {
            $a->{ $b->ordernumber } //= {
                ordernumber => $b->ordernumber,
                orderdate   => $b->orderdate,
                purchases   => []
            };

            my $purchase = {
                customer     => $b->search_related('customerid'),
                item         => $b->search_related('itemid'),
                manufacturer => $b->search_related('itemid')->search_related('manufacturerid')
            };

            # Generate sort order so we don't need to collapse the resultset with a group_by
            push(@sort_order, $b->ordernumber) unless defined $sort_order[-1] && $sort_order[-1] eq $b->ordernumber;

            # Add purchase to the list of purchases for this ordernumber
            push @{ $a->{ $b->ordernumber }{purchases} }, $purchase;

            $a;
        } ( {}, @orders );

        my @sorted_orders = map { $orders->{$_} } @sort_order;

        return \@sorted_orders
    }

    # Insert a new order record
	fun insert_order (HashRef $order_info) {
        my $manufacturer = resultset('Manufacturer')->find_or_create({
            manufacturername => $order_info->{item_manufacturer_name}
        });        

        my $item = resultset('Item')->find_or_create({
            manufacturerid => $manufacturer->manufacturerid,
            itemname       => $order_info->{item_name},
            itemprice      => $order_info->{item_price}
        });

        my $customer = resultset('Customer')->find_or_create({
            customerid        => $order_info->{customer_id},
            customerfirstname => $order_info->{customer_first_name},
            customerlastname  => $order_info->{customer_last_name},
        });

        my $order = resultset('Order')->create({
            ordernumber => $order_info->{order_number},
            orderdate   => $order_info->{order_date},
            customerid  => $customer->id,
            itemid      => $item->id,            
        });

        return {
            order        => $order,
            manufacturer => $manufacturer,
            customer     => $customer,
            item         => $item
        }
	}
}

1;