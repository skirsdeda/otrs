# --
# HTML/Installer.pm - provides installer HTML output
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Installer.pm,v 1.2 2002-10-24 23:55:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Installer;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub InstallerStart {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->InstallerBody(
        %Param,
        Body => $Self->Output(TemplateFile => 'InstallerStart', Data => \%Param),
    );
}
# --
sub InstallerSystem {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'InstallerSystem', Data => \%Param);
}
# --
sub InstallerFinish {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'InstallerFinish', Data => \%Param);
}
# --
sub InstallerBody {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'InstallerBody', Data => \%Param);
}
# --

1;
 
