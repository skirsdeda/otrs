# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewCustomerRelationTables;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewCustomerRelationTables - Adds new tables for customer relations.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # group_customer - relation group<->customer
        '<Table Name="group_customer">
            <Column Name="customer_id" Required="true" Size="150" Type="VARCHAR"/>
            <Column Name="group_id" Required="true" Type="INTEGER"/>
            <Column Name="permission_key" Required="true" Size="20" Type="VARCHAR"/>

            <!-- Here permission_value is still used (0/1) because CustomerGroup.pm
                was not yet refactored like Group.pm. -->
            <Column Name="permission_value" Required="true" Type="SMALLINT"/>

            <Column Name="permission_context" Required="true" Size="100" Type="VARCHAR"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>
            <Index Name="group_customer_customer_id">
                <IndexColumn Name="customer_id"/>
            </Index>
            <Index Name="group_customer_group_id">
                <IndexColumn Name="group_id"/>
            </Index>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="groups">
                <Reference Local="group_id" Foreign="id"/>
            </ForeignKey>
        </Table>',

        # customer_user_customer - relation customer user<->customer
        '<Table Name="customer_user_customer">
            <Column Name="user_id" Required="true" Size="100" Type="VARCHAR"/>
            <Column Name="customer_id" Required="true" Size="150" Type="VARCHAR"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>
            <Index Name="customer_user_customer_user_id">
                <IndexColumn Name="user_id"/>
            </Index>
            <Index Name="customer_user_customer_customer_id">
                <IndexColumn Name="customer_id"/>
            </Index>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </Table>',
    );

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string (only for new tables)
        if ( $XMLString =~ m{ <Table \s+ Name="([^"]+)" }xms ) {
            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # check if table exists already
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            next XMLSTRING if $TableExists;
        }

        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
