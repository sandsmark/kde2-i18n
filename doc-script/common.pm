#      file: common (.pm)
#   version: 1999.07.11
#     title: KDE Documentation statistics
#  subtitle: Common Data
#    author: Tobias Burnus, burnus@gmx.de
# copyright: LGPL
#  homepage: http://mimas.germany.net:8080/kde-doc/
# 
# This files contains some standards, which may be overwritten in the
# checkDoc<Language> files.

#use strict;
$dir = '/home/burnus/doc-stat/docs/';
#$CVSWEB = 'http://kdecvs.stud.fh-heilbronn.de/cvsweb/';
#$CVSWEB = 'http://www.nebsllc.com/cgi-bin/cvsweb.cgi/';
$CVSWEB = 'http://us.mandrakesoft.com/cgi-bin/cvsweb.cgi/'; #?hideattic=1

$comIntro = '
<p>This is a daily run documentation statistic.
An extensive description of this page is <A
href="http://i18n.kde.org/stats/doc/doc-stat.html">available</A>,
have also a look at the <A href="http://i18n.kde.org/stats/doc/">main
page</A>.
Please send a email to <A href="mailto:burnus@gmx.de">Tobias Burnus</A>
if you want to make a comment or miss a file.</P>

<P>NOTE: The new directory structure is NOT yet reflected in the 
<A href="#etc">other files</A> section. The rest should be up to date (please double check whether it works now!</p>';

$comKDELinks = '
<p>[<A href="#kdeadmin">KDEAdmin</A> | <A href="#kdebase">KDEBase</A>
| <A href="#kdegames">KDEGames</A> | <A href="#kdegraphics">KDEGraphics</A>
| <A href="#kdelibs">KDELibs</A> | <A href="#kdemultimedia">KDEMultimedia</A>
| <A href="#kdenetwork">KDENetwork</A> | <A href="#kdeutils">KDEUtils</A>
| <A href="#kdetoys">KDEToys</A> | <A href="#koffice">KOffice</A>
| <A href="#kdevelop">KDevelop</A>
| <a href="#kdepim">kdepim</a>
| <A href="#kfte">KFTE</A>| <A href="#ksite">KSite</A>';


package common;

my $goTop;
my $Lng;
my $lng;
my $CVSWEB = $main::CVSWEB;

sub set_Lng {
  $Lng = shift;
}

sub set_lng {
  $lng = shift;
}
sub set_goTop {
  $goTop = shift;
}

sub comKdeStd {
  comKdeStdAdmin();
  comKdeStdBase();
  comKdeStdGames();
  comKdeStdGraphics();
  comKdeStdLibs();
  comKdeStdMultimedia();
  comKdeStdNetwork();
  comKdeStdUtils();
  comKdeStdToys();
  comKdePim
}

sub comKdeStdAdmin {
print '<H2><A name="kdeadmin"></A>KDEAdmin
[<A href="'.$CVSWEB.'kdeadmin/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdeadmin/">'.$Lng.'</A>]</H2>'.$goTop;
main::checkDoc::printDir('kdeadmin/doc/','kde-i18n/'.$lng.'/docs/kdeadmin/');
}

sub comKdeStdBase {
print '<H2><A name="kdebase"></A>KDEBase
[<A href="'.$CVSWEB.'kdebase/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdebase/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdebase/doc/','kde-i18n/'.$lng.'/docs/kdebase/');
}

sub comKdeStdGames {
print '<H2><A name="kdegames"></A>KDEGames
[<A href="'.$CVSWEB.'kdegames/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdegames/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdegames/doc/','kde-i18n/'.$lng.'/docs/kdegames/');
}

sub comKdeStdGraphics {
print '<H2><A name="kdegraphics"></A>KDEGraphics
[<A href="'.$CVSWEB.'kdegraphics/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdegraphics/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdegraphics/doc/','kde-i18n/'.$lng.'/docs/kdegraphics/');
}

sub comKdeStdLibs {
print '<H2><A name="kdelibs"></A>KDELibs
[<A href="'.$CVSWEB.'kdelibs/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdelibs/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdelibs/doc/','kde-i18n/'.$lng.'/docs/kdelibs/');
}

sub comKdeStdMultimedia {
print '<H2><A name="kdemultimedia"></A>KDEMultimedia
[<A href="'.$CVSWEB.'kdemultimedia/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdemultimedia/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdemultimedia/doc/','kde-i18n/'.$lng.'/docs/kdemultimedia/');
}

sub comKdeStdNetwork {
print '<H2><A name="kdenetwork"></A>KDENetwork
[<A href="'.$CVSWEB.'kdenetwork/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdenetwork/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdenetwork/doc/','kde-i18n/'.$lng.'/docs/kdenetwork/');
}

sub comKdeStdUtils {
print '<H2><A name="kdeutils"></A>KDEUtils
[<A href="'.$CVSWEB.'kdeutils/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdeutils/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdeutils/doc/','kde-i18n/'.$lng.'/docs/kdeutils/');
}

sub comKdeStdToys {
print '<H2><A name="kdetoys"></A>KDEToys
[<A href="'.$CVSWEB.'kdetoys/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdetoys/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdetoys/doc/','kde-i18n/'.$lng.'/docs/kdetoys/');
}

# Still active? - doc is on a strange place => to correct
sub comKFTE {
print '<H2><A name="kfte"></A>KFTE
[<A href="'.$CVSWEB.'kfte/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kfte/'.$lng.'">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kfte/doc/kfte/','kde-i18n/'.$lng.'/docs/kfte/');
}

sub comKDevelop {
print '<H2><A name="kdevelop"></A>Kdevelop
[<A href="'.$CVSWEB.'kdevelop/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/kdevelop/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdevelop/doc/','kde-i18n/'.$lng.'/docs/kdevelop/');
}

sub comKOffice {
print '<H2><A name="koffice"></A>KOffice
[<A href="'.$CVSWEB.'koffice/doc/">En</A> |
 <A href="'.$CVSWEB.'kde-i18n/'.$lng.'/docs/koffice/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('koffice/doc/','kde-i18n/'.$lng.'/docs/koffice/');
}

# KDEPim

sub comKdePim {
print '<H2><A name="kdepim"></A>KDEpim
[<A href="'.$CVSWEB.'kdepim/doc/en/">En</A> |
 <A href="'.$CVSWEB.'kdepim/doc/'.$lng.'/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('kdepim/doc/en/','kde-i18n/'.$lng.'/docs/kdepim/');
}

# Is this still active?
sub comKSite {
print '<H2><A name="ksite"></A>KSite
[<A href="'.$CVSWEB.'ksite/doc/en/">En</A> |
 <A href="'.$CVSWEB.'ksite/doc/'.$lng.'/">'.$Lng.'</A>]</H2>'.$goTop;
checkDoc::printDir('ksite/doc/en/','kde-i18n/'.$lng.'/docs/ksite/');
}


1;
