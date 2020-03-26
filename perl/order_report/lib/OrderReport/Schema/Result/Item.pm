use utf8;
package OrderReport::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OrderReport::Schema::Result::Item

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

=head1 TABLE: C<item>

=cut

__PACKAGE__->table("item");

=head1 ACCESSORS

=head2 itemid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 itemname

  data_type: 'text'
  is_nullable: 0

=head2 itemprice

  data_type: 'real'
  is_nullable: 0

=head2 manufacturerid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "itemid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "itemname",
  { data_type => "text", is_nullable => 0 },
  "itemprice",
  { data_type => "real", is_nullable => 0 },
  "manufacturerid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</itemid>

=back

=cut

__PACKAGE__->set_primary_key("itemid");

=head1 RELATIONS

=head2 manufacturerid

Type: belongs_to

Related object: L<OrderReport::Schema::Result::Manufacturer>

=cut

__PACKAGE__->belongs_to(
  "manufacturerid",
  "OrderReport::Schema::Result::Manufacturer",
  { manufacturerid => "manufacturerid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 orders

Type: has_many

Related object: L<OrderReport::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "OrderReport::Schema::Result::Order",
  { "foreign.itemid" => "self.itemid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-07-19 19:00:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1Tz9mw/dtM4f/xTO5BFngA


# You can replace this text with custom code or comments, and it will be preserved on regeneration


use Locale::Currency::Format;

sub formatted_price {
  return currency_format('USD', $_[0]->itemprice);
}


1;
