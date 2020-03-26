use utf8;
package OrderReport::Schema::Result::Customer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OrderReport::Schema::Result::Customer

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<customer>

=cut

__PACKAGE__->table("customer");

=head1 ACCESSORS

=head2 customerid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 customerfirstname

  data_type: 'text'
  is_nullable: 0

=head2 customerlastname

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "customerid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "customerfirstname",
  { data_type => "text", is_nullable => 0 },
  "customerlastname",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</customerid>

=back

=cut

__PACKAGE__->set_primary_key("customerid");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<OrderReport::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "OrderReport::Schema::Result::Order",
  { "foreign.customerid" => "self.customerid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-07-19 19:00:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7VmiL18LKEGmdiciNVGvgw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
