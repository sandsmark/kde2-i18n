#!/usr/bin/perl

# Message Splitter
# 
# This software is in the public domain.
# There are no restrictions on any sort of usage of this software.
# 
# $po-tools: msgsplit.pl,v 1.2.1 2000/10/29 13:38:00 Toshihiro Inoue Exp $

$MAXLINE = 78;

$str = "";
$flg = 0;
while(<STDIN>){
  while(substr($_, -1) eq "\n"){
    chop;
  }
  $oldflg = $flg;
  $flg = 0;
  $flg = 1 if !/^\#/ && /\".*\"/;
  $flg = 2 if /^\".*\"/;
  if($flg != 2 && $oldflg != 0){
    prtStr($str);
    $str = "";
  }
  if($flg == 0){
    print "$_\n";
  }else{
    if($flg == 1){
      $a = $_;
      $a =~ s/^(.*?)\".*\".*?$/$1/;
      print $a;
    }
    s/^.*?\"(.*)\".*?$/$1/;
    $str .= $_;
  }
}
prtStr($str) if $flg != 0;
exit;

sub prtStr
{
  my($s) = $_[0];
  my($h1, $h2);
  for(;;){
    last if $s !~ /(=[0-9A-Fa-f]{2}){3}/;
    $h1 = $s;
    $h1 =~ s/^.*((=[0-9A-Fa-f]{2}){3}).*$/$1/;
    $h2 = chr(hex(substr($h1, 1, 2))) . chr(hex(substr($h1, 4, 2))) . chr(hex(substr($h1, 7, 2)));
    $s =~ s/$h1/$h2/;
  }
  my($ll, $c, $cl);
  my($flg) = 1;
  my($i) = 0;
  my($l) = length($s);
  my($ss) = "";
  while($i < $l){
    $cl = charLen($s, $i);
    $c = substr($s, $i, $cl);
    $ll += $cl;
    if($ll >= $MAXLINE){
      if($flg){
	print "\"\"\n";
	$flg = 0;
      }
      $st = $ss;
      $st =~ s/ [^\s]*$/ /;
     
      if (length($st) > $MAXLINE - 2) { # still
          $st =~ s/>[^>]*$/>/;
      }
      if (length($st) > $MAXLINE - 2) { # still
          $st = $ss;
      }

      $ss = substr($ss, length($st));
      print "\"$st\"\n";
      $ll = $cl + length($ss);
    }
    $ss .= $c;
    if($c eq "\\n"){
      if($flg){
	print "\"\"\n";
	$flg = 0;
      }
      print "\"$ss\"\n";
      $ss = "";
      $ll = 0;
    }
    $i += $cl;
  }
  if($ss ne ""){
    print "\"$ss\"\n";
  }elsif($flg){
    print "\"\"\n";
  }
}

sub charLen
{
  my($s) = $_[0];
  my($p) = $_[1];
  my($l) = length($s);
  return 0 if $p >= $l;
  my($c1, $c2, $c3);
  $c1 = ord(substr($s, $p, 1));
  return 2 if $c1 == ord('\\');
  return 1 if $c1 < 0xc0;
  $p++;
  return 1 if $p >= $l;
  $c2 = ord(substr($s, $p, 1));
  return 1 if $c2 < 0x80 || 0xc0 <= $c2;
  return 2 if $c1 < 0xe0;
  $p++;
  return 1 if $p >= $l;
  $c3 = ord(substr($s, $p, 1));
  return 1 if $c2 < 0x80 || 0xc0 <= $c2;
  return 3;
}
