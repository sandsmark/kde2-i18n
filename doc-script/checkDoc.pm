#      file: checkDoc.pm
#   version: 1999.07.14
#     title: KDE Documentation statistics
#  subtitle: main module
#    author: Tobias Burnus, burnus@gmx.de
# copyright: LGPL
# acknowledgement: Thanks to Frederik Fouvry for suggestions

# Steps:
# 1 find files in the english tree
#   a) sgml files
#   b) htm(l) files w/o '-*.htm'
#   c) ommit those html files which have a <name>.sgml counterpart
# 2 find files in the german tree
#   a) check whether there exists an sgml counterpart to a) sgml or b) html
#   b) if only one sgml file is in both directories make the guess that
#      <whatever>.{html/sgml} and <foobar>.{html/sgml} are the same (and mark it
#      on the table)
#   c) write the left overs to the table
#

package checkDoc ;

use strict;
use File::stat; # for file date
use Time::localtime;
use Time::Local;

my $CVSWEB;
my $OfDir;
my $tableHeader;
my $Lng;
my $sExists;
my $sNoEngl;
my $sIsUpToDate;
my $sIsTooOld;
my $useComments = 0; # 1|0
my $sComment;
my $sPerhaps;
my $commentFile;
my $refDate = Time::Local::timegm(0,0,0,12,(5)-1,1999);
#                                ($second,$minute,$hours,$day,$month-1,$year)
# This is used for the up-to-date column, if a translated file is older than 
# this date, but newer than the original file, a 'Perhaps' is printed,
# so you might need to check that file.

sub set_CVSWEB        {$CVSWEB      = shift;}
sub set_OfDir         {$OfDir       = shift;}
sub set_TableHeader   {$tableHeader = shift;}
sub set_Language      {$Lng         = shift;}
sub set_strExists     {$sExists     = shift;}
sub set_strNoEngl     {$sNoEngl     = shift;}
sub set_strComment    {$sComment    = shift;}
sub set_strIsUpToDate {$sIsUpToDate = shift;}
sub set_strIsTooOld   {$sIsTooOld   = shift;}
sub set_strPerhaps    {$sPerhaps    = shift;}
sub set_refDate       {$refDate     = shift;}
sub set_commentFile   {$commentFile = shift;}
sub set_useComments   {$useComments = shift;}

######################################################
# SUB void printDir(String origPath, String transPath)
# Main Function
# Parametres: English path, Translated file path
######################################################
sub printDir
{
  my $enDir = shift;
  my $trDir = shift; # translated documentation directory
  my @lstEn = createList($enDir,'');
  my @lstTr = createList($trDir,'');
  chomp(@lstEn); # remove tailing '\n'
  chomp(@lstTr);
  my $l; my $o;
  
  print "<table border=\"1\" bgcolor=\"#FFFFAA\">\n".$tableHeader."\n";
  my @comments = ();
  foreach(@lstEn)
  { 
     my $exists=0;
     if($useComments)
     {
       my ($gmdate,$user,$comment) = findComment($enDir.$_);
       if($gmdate !=0) # A comment exists
       {
          push(@comments,'<strong>En:'.$_.':</strong> '.$comment.' ('.$user.', '
	                                                 .ctime($gmdate).')');
       }
       ($gmdate,$user,$comment) = findComment($trDir.$_);
       if($gmdate !=0) # A comment exists
       {
          push(@comments,'<strong>'.$Lng.':'.$_.':</strong> '.$comment.' ('.$user.', '
	                                                 .ctime($gmdate).')');
       }
     }

    print '<tr><td';
    if(isHTML($_)) {print ' bgcolor="#FF8080"';}
    print "><A href=\"$CVSWEB$enDir$_\">".$_."</A></td>";
    if(isInArray($_,@lstTr))
    {
      $exists=1;
      print "<td bgcolor=\"#00FF00\"><A href=\"$CVSWEB$trDir$_\">$sExists</A></td>";
      print isUptodate($OfDir.$enDir.$_, $OfDir.$trDir.$_);
      my ($date,$rev) = getVersion($_,$enDir);
      print "<td>$date / $rev</td>";
      ($date,$rev) = getVersion($_,$trDir);
      print "<td>$date / $rev</td>";
    }
    else
    {
      print "<td>--</td><td>--</td>";
      my ($date,$rev) = getVersion($_,$enDir);
      print "<td>$date / $rev</td></td><td>--</td>";
    }
    if(!isHTML($_))
    {
     print "<td><small>".`grep '<date>' $OfDir$enDir$_`."</small></td>";
    }
    else { print "<td>--</td>";}
    if(!isHTML($_) && $exists)
    {
      print "<td><small>".`grep '<date>' $OfDir$trDir$_`."</small></td>";
    }
    else {print "<td>&nbsp;</td>"}
    print "</tr>\n";
  }
  
  foreach(@lstTr)
  { 
    if(!isInArray($_,@lstEn))
    {
      if($useComments)
      {
        my ($gmdate,$user,$comment) = findComment($enDir.$_);
        if($gmdate !=0) # A comment exists
        {
           push(@comments,'<strong>En:'.$_.':</strong> '.$comment.' ('.$user.', '
                                                   .ctime($gmdate).')');
        }
        ($gmdate,$user,$comment) = findComment($trDir.$_);
        if($gmdate !=0) # A comment exists
        {
           push(@comments,'<strong>'.$Lng.':'.$_.':</strong> '.$comment.' ('.$user.', '
                                                   .ctime($gmdate).')');
        }
      }
      if(isHTML($_))
      {
        print "<tr><td bgcolor=\"#FF8080\"><strong><A href=\"$CVSWEB$trDir$_\">$Lng:"
              ."$_</A></strong></td>"."<td>$sNoEngl</td>"
	      ."<td>--</td><td>--</td>";
      }
      else {
        print "<tr><td><strong><A href=\"$CVSWEB$trDir$_\">$Lng:"
              ."$_</A></strong></td>"."<td>$sNoEngl</td>"
	      ."<td>--</td><td>--</td>";
      }
      my ($date,$rev) = getVersion($_,$trDir);
      print "<td>$date / $rev</td>";
      if(isHTML($_))
      {
        print "<td>&nbsp;</td><td>--</td>";
      }
      else { print "<td>&nbsp;</td><td><small>".`grep '<date>' $OfDir$trDir$_`."</small></td>"; }
      print '</tr>';
    }
  }
  print "</table>";
  if($#comments >0)
  {
    print "<p><strong>$sComment:</strong> ";
    foreach(@comments) {print $_.' ';}
    print "</p>";
  }
}

###############
# SUB String isUptodate(string fileOrig,string fileTrans)
# checks whether the translated file is newer, older or 'perhaps' newer
# as the original file is.
###############
sub isUptodate
{
  my $orgFile   = shift;
  my $transFile = shift;
  if((stat($transFile)->mtime) < $refDate)
    {return '<td bgcolor="#FFAF60">'.$sPerhaps.'</td>';}
  elsif((stat($transFile)->mtime) < (stat($orgFile)->mtime))
    {return '<td bgcolor="#FF8080">'.$sIsTooOld.'</td>';}
  else {return '<td bgcolor="#00FF00">'.$sIsUpToDate.'</td>';}
}

###############
# SUB String[] createList(String directory, prune directory)
# The file find procedure. Looks in the given directory for sgml and html files,
# and cancels the html files names which are identical to sgml but extention;
# moreover '*-XX.*' files are removed, where XX is a number.
###############
sub createList
{
   my $dir = shift;
   my $prune = shift;
   my @ffiles  = `find $OfDir$dir -name '*.docbook';
                  find $OfDir$dir -name '*.sgm*'`;
   my @ffiles2 = `find $OfDir$dir -name '*.htm*'`;
   # remove the html files which have a sgml counterpart
   foreach(@ffiles2)
   {
     my $sstr = stripExtentions($_);
     if(!isChildStr($sstr)) # Remove foo-12.html files
     {
       if(!isInTArray($_,@ffiles))
         {push(@ffiles,$_);}
     }
   }
   
   @ffiles2 = ();
   my $len = length($OfDir.$dir);
   foreach(@ffiles)
   {
      push(@ffiles2,substr($_,$len,length($_)-$len));
   }
   return @ffiles2;
}

############################################
# SUB: (String,String) getVersion(String filename, String module)
#      returns (date,revision)
############################################
sub getVersion
{
   my $fname = shift;
   my $modDir = shift;
   my ($Dir,$File) = extractFilename($fname);
   my ($null,$file,$rev,$date) = split /\//,`grep $File $OfDir$modDir$Dir/CVS/Entries`;
   return ($date,$rev);
}

############################################
# SUB: (String,String) extractFilename(String)
#      returns (path,filename)
############################################
sub extractFilename
{
  my $fname = shift;
  my $i = length($fname)-1;
  for(;$i>=0;$i--)
  {
    if(substr($fname,$i,1) eq '/')
      { return (substr($fname,0,$i),substr($fname,$i+1,length($fname)-1)); }
  }
  return('',$fname);
}

############################################
# SUB: String stripExtentions(String)
#      removes the last '.*' part of a file
############################################
sub stripExtentions
{
  my $fname = shift;
  return $fname =~ s/\.[^.]*//oi;
}

###############################################
# SUB BOOL isChildStr (String)
#     states whether a string ends with a digit
#     as in /foo/bar-1 (.html)
###############################################
sub isChildStr
{
  my $str = shift;
  return isdigit(substr($str,length($str)-1,1));
}

sub isdigit
{
  my $c = shift;
  if ((ord($c) >= ord('0')) && (ord($c) <= ord('9'))){ return 1}
  else{ return 0;}
}

###############################################
# SUB BOOL isInTArray(String[], String)
#     tests if a String is already in an array.
#     note: both string and array elements are previously striped
###############################################
sub isInTArray
{
  my ($str,@Array) = @_;
  my $ststr = stripExtentions($str);
  foreach(@Array)
  {
    if($ststr eq stripExtentions($_)) {return 1;}
  }
  return 0;
}

###############################################
# SUB BOOL isInTArray(String[], String)
#     tests if a String is already in an array.
#     note: both string and array elements are previously striped
###############################################
sub isInArray
{
  my ($str,@Array) = @_;
  foreach(@Array)
  {
    if($str eq $_) {return 1;}
  }
  return 0;
}

###############################################
# SUB BOOL isHTML(String filename)
###############################################
sub isHTML
{
   my $fn = shift;
   return ( (substr($fn,length($_)-3,3)eq 'htm')||(substr($fn,length($_)-4,4)eq 'html')
          ||(substr($fn,length($_)-3,3)eq 'sgm')||(substr($fn,length($_)-4,4)eq 'sgml'));
}

###############################################
# SUB findComment
###############################################
sub findComment
{
   my $filename = shift;
   my $gdata = `grep '^'$filename $commentFile`;
   if($gdata ne '')
   {
     my ($file,$date,$user,$comment) = split /:/,$gdata;
     my ($yr,$m,$d) = split /-/,$date;
     my $gmdate = Time::Local::timegm(0,0,0,$d,($m)-1,$yr);
     chomp($comment);
     return ($gmdate,$user,$comment);
   }
   return(0,0,0);
}
# and the obligatory:
1;
