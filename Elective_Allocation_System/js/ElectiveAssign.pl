#!/usr/bin/perl
use strict;
use warnings;

#This Script written by Anjeneya Swami Kare
#reading command line argument
my $argc = $#ARGV + 1; 
if ($argc != 2)
{
    print "Invalid argument, Enter csv file of elective preferences\n";
    exit;
}

#reading the elective preferences file
my $file = $ARGV[0];
open FILE, $file or die "Couldn't open file: $!";
my $i = 0;
my @lines;
while(<FILE>)
{
    $lines[$i] = $_;
    chomp($lines[$i]);
    $i = $i + 1;
}
close FILE;
#my @lines = split('\n', $content);


#Reading number of electives and buckets
my $firstline = $lines[0];
my @buckets = split(',', $firstline);
@buckets = @buckets[4 .. $#buckets];
my $secondline = $lines[1];
my @electives = split(',', $secondline);
@electives = @electives[4 .. $#electives];
my $elecount = $#electives + 1;

#reading the students list
my @mtcslist = getList("MTechCS", "MTechAI", @lines);
my @mtailist = getList("MTechAI", "MCAIII", @lines);
#my @mtitlist = getList("MTechIT", "MCAIII", @lines);
my @mca3list = getList("MCAIII", "IMTechVII", @lines);
my @imt7list = getList("IMTechVII", "MCAV", @lines);
my @mca5list = getList("MCAV", "FILEEND", @lines);

#print @imtlist;

#reading elective limits
my $limitfile = $ARGV[1];
open FILE, $limitfile or die "Couldn't open file: $!";
my @elelimits;
$i = 0;
while(<FILE>)
{
    $elelimits[$i] = $_;
    chomp($elelimits[$i]);
    $i = $i + 1;
}
close FILE;

my @mtcslimits = split(',', $elelimits[1]);
@mtcslimits = @mtcslimits[1 .. $#mtcslimits];
#print @mtcslimits;

my @mtailimits = split(',', $elelimits[2]);
@mtailimits = @mtailimits[1 .. $#mtailimits];

#my @mtitlimits = split(',', $elelimits[3]);
#@mtitlimits = @mtitlimits[1 .. $#mtitlimits];

my @mca3limits = split(',', $elelimits[3]);
@mca3limits = @mca3limits[1 .. $#mca3limits];

my @imt7limits = split(',', $elelimits[4]);
@imt7limits = @imt7limits[1 .. $#imt7limits];


my @mca5limits = split(',', $elelimits[5]);
@mca5limits = @mca5limits[1 .. $#mca5limits];

my @allocatedcount;
my @allocatedlist;
for($i = 0; $i < $elecount; $i = $i + 1)
{
    $allocatedcount[$i] = 0;
    $allocatedlist[$i] = "";
}

#my @mtcsalloc = optioncore(\@mtcslist);
#printcoursestrength();
#@mtcsalloc = ellocate(\@mtcsalloc, \@mtcslist, \@mtcslimits, 1);
#print "MTCS:\n";
#printallocation(\@mtcsalloc);
#printcoursestlist();
#printcoursestrength();


#my @mtaialloc = optioncore(\@mtailist);
#my @mtaialloc = addfront(\@mtailist);
#@mtaialloc = ellocate(\@mtaialloc, \@mtailist, \@mtailimits, 1);
#print "MTAI:\n";
#printallocation(\@mtaialloc);
#printcoursestlist();
#printcoursestrength();

#my @mtitalloc = optioncore(\@mtitlist);
#@mtitalloc = ellocate(\@mtitalloc, \@mtitlist, \@mtitlimits, 1);


#my @mca3alloc = addfront(\@mca3list);
#@mca3alloc = ellocate(\@mca3alloc, \@mca3list, \@mca3limits, 1);
#print "MCAIII:\n";
#printallocation(\@mca3alloc);
#printcoursestlist();
#printcoursestrength();

my @imt7alloc = addfront(\@imt7list);
@imt7alloc = ellocate(\@imt7alloc, \@imt7list, \@imt7limits, 2);
print "IMTVII:\n";
printallocation(\@imt7alloc);
#printcoursestlist();
#printcoursestrength();

#my @mca5alloc = addfront(\@mca5list);
#@mca5alloc = ellocate(\@mca5alloc, \@mca5list, \@mca5limits, 4);
#print "MCAV: \n";
#printallocation(\@mca5alloc);
#printcoursestlist();
#printcoursestrength();


sub addfront
{
    my ($students_ref) = @_;
    my @students = @{ $students_ref };
    my @alloc;

    for(my $i = 0; $i <= $#students; $i = $i + 1)
    {
	 my @tokens = split(',', $students[$i]);
	 $alloc[$i] = "$tokens[1],$tokens[2],";
    }
    return @alloc;
}
sub printcoursestlist
{
    print "\nCourse wise student list: \n";
    for($i = 0; $i < $elecount; $i = $i + 1)
    {
	print $electives[$i];
	print ":\n";
	print $allocatedlist[$i];
        print "\n";    
    }
}

sub printcoursestrength
{
    print "\nCourse Stregth Sofar: \n";
    for($i = 0; $i < $elecount; $i = $i + 1)
    {
	print $electives[$i];
	print ": ";
	print $allocatedcount[$i];
	print "\n";
    }
    print "\n";
}

sub printallocation
{
    print "\nCourse Allocation Sofar: \n";
    my ($alloc_ref) = @_;
    my @allocation = @{ $alloc_ref };
    for($i = 0; $i <= $#allocation; $i = $i + 1)
    {
	print $allocation[$i];
	print "\n";
    }
}

sub ellocate
{
    my ($alloc_ref, $students_ref, $limits_ref, $count) = @_;
    my @allocation = @{ $alloc_ref };
    my @students = @{ $students_ref };
    my @limits = @{ $limits_ref };
    my $countalloc = 0;
    my @allocated;
    my @ranktoprocess;
    for(my $i = 0; $i <= $#students; $i = $i + 1)
    {
	@allocated[$i] = $count;
	@ranktoprocess[$i] = 1;


    }
    for(my $i = 0; $i < $count; $i = $i + 1)
    {
	for(my $j = 0; $j <= $#students; $j = $j + 1)
	{
	    my @tokens = split(',', $students[$j]);
	    my $flag = 0;
	    my $k;
	    for($k = $ranktoprocess[$j]; $k <= $elecount; $k = $k + 1)
	    {
		for(my $l = 4; $l <= $#tokens; $l = $l + 1)
		{
		    if($tokens[$l] =~ /^\d+$/ and $tokens[$l] == $k)
		    {
		        my $str = "$buckets[$l - 4],";
			if($allocated[$j] > 0 and ($allocation[$j] !~ m/$str/) and $limits[$l-4] > 0)
			{
			    @allocation[$j] = $allocation[$j]."$electives[$l - 4],$buckets[$l - 4],";
			    $allocatedcount[$l - 4] = $allocatedcount[$l - 4] + 1;
			    $allocatedlist[$l - 4] = $allocatedlist[$l - 4]."$tokens[1],$tokens[2]\n";
			    $limits[$l-4]--;
			    $allocated[$j]--;
			    $flag = 1;
			    last;
			}
		    }	    
		}
		if($flag == 1)
		{
		    last;
		}
	    }
	    if($flag == 0)
	    {
                @allocation[$j] = $allocation[$j]."MANUAL,ATTENTION,";
	    }
	    @ranktoprocess[$j] = $k + 1;
	}
    }
   return @allocation;
}

sub reading {
    my ($course) = @_;
    print "Enter number of electives (excluding optional core) to be taken by $course: ";
    my $number = <STDIN>;
    chomp $number;
    return $number;
}

sub optioncore
{
    my ($students_ref) = @_;
    my @students = @{ $students_ref };
    my @alloc;

    for(my $i = 0; $i <= $#students; $i = $i + 1)
    {
	my @tokens = split(',', $students[$i]);
	my $flag = 0;
	$alloc[$i] = "$tokens[1],$tokens[2],";
	for(my $j = 0; $j <= $#tokens; $j = $j + 1)
	{
	    if($tokens[$j] =~ m/Optional Core/i)
	    {
		$alloc[$i] = $alloc[$i]."$electives[$j - 4],$buckets[$j - 4],";		
		$flag = 1;
		$allocatedcount[$j - 4] = $allocatedcount[$j - 4] + 1;
		$allocatedlist[$j - 4] = $allocatedlist[$j - 4]."$tokens[1],$tokens[2]\n";
	    }	    
	}
	if($flag == 0)
	{
	    $alloc[$i] = "$tokens[1],$tokens[2],";	    
	}	
    }    
    return @alloc;
}

#function to get student list of particular stream
sub getList
{
    my $n = scalar(@_);
    my $startok = $_[0];
    my $endtok = $_[1];
    my $start = -1;
    my $end = -1;
    for(my $i = 2; $i < $n; $i++)
    {
	if($start == -1 and $_[$i] =~ m/$startok/)
	{
	    $start = $i + 1;
	}
	if($_[$i] =~ m/$endtok/)
	{
	    $end = $i - 1;
	    last;
	}
	if($i == $n - 1)
	{
	    $end = $i;
	    last;
	}
    }
    my @stdlist = @_[$start..$end];
    return @stdlist;
}
