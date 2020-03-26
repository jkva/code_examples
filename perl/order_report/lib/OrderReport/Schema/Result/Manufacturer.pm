use utf8;
package OrderReport::Schema::Result::Manufacturer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OrderReport::Schema::Result::Manufacturer

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

=head1 TABLE: C<manufacturer>

=cut

__PACKAGE__->table("manufacturer");

=head1 ACCESSORS

=head2 manufacturerid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 manufacturername

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "manufacturerid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "manufacturername",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</manufacturerid>

=back

=cut

__PACKAGE__->set_primary_key("manufacturerid");

=head1 RELATIONS

=head2 items

Type: has_many

Related object: L<OrderReport::Schema::Result::Item>

=cut

__PACKAGE__->has_many(
  "items",
  "OrderReport::Schema::Result::Item",
  { "foreign.manufacturerid" => "self.manufacturerid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-07-19 14:05:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FmzXrRgDR2yAl+vWGc87vg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
