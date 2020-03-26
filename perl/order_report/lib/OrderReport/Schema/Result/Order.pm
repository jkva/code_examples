use utf8;
package OrderReport::Schema::Result::Order;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OrderReport::Schema::Result::Order

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

=head1 TABLE: C<order>

=cut

__PACKAGE__->table("order");

=head1 ACCESSORS

=head2 orderid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 ordernumber

  data_type: 'text'
  is_nullable: 0

=head2 orderdate

  data_type: 'text'
  is_nullable: 0

=head2 itemid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 customerid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "orderid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ordernumber",
  { data_type => "text", is_nullable => 0 },
  "orderdate",
  { data_type => "text", is_nullable => 0 },
  "itemid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "customerid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</orderid>

=back

=cut

__PACKAGE__->set_primary_key("orderid");

=head1 RELATIONS

=head2 customerid

Type: belongs_to

Related object: L<OrderReport::Schema::Result::Customer>

=cut

__PACKAGE__->belongs_to(
  "customerid",
  "OrderReport::Schema::Result::Customer",
  { customerid => "customerid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 itemid

Type: belongs_to

Related object: L<OrderReport::Schema::Result::Item>

=cut

__PACKAGE__->belongs_to(
  "itemid",
  "OrderReport::Schema::Result::Item",
  { itemid => "itemid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-07-19 19:00:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uiGKeWPetII5VHuPn+dPng


# You can replace this text with custom code or comments, and it will be preserved on regeneration

1;
