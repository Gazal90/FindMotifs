#!usr/bin/perl
#
open(PR,$ARGV[0]); #promoter sequences fasta file
open(MOT,$ARGV[1]); #$motif sequences file #has motif sequences to be searched for.
@motifs=<MOT>;#print $#motifs;
foreach $abc(@motifs)
{	chomp $abc;
	$data{$abc}=$abc;
}
@ids="MOTIFS";	#will be the header
while(<PR>)	#for each promoter and header
{chomp;
	if($_ !~ />/)								#make sure only promoter seq dealt with
	{	$len_P=length($_);						#length of promoter
		foreach $m(@motifs)						#search for each motif in the present promoter
		{	chomp $m;
			$matches=0;
			$len_motif=length($m);					#length of current motif
			$pos=0;$len_P_left=$len_P;				#length to match in loop
			while($len_P_left>=$len_motif)				#loop goes on until length of remaining promoter is greater than length of motif
			{	$to_match=substr $_,$pos,$len_motif;		#cuts promoter equal to length of motif from one position forward word than the last word
				$pr_seq_left=substr $_,$pos+1;			#promoter seq left to match
				if($to_match eq $m)
				{	$matches++;
				}
				$len_P_left=length($pr_seq_left);		#length of promoter seq left to match
			$pos++;
			}
			$data{$m}=$data{$m}."\t".$matches;			#each hash element will be a line for a motif in output
		}
	}
	else{chomp $_;push @ids, $_;}
}
	foreach $i(@ids){chomp $i;print "$i\t";}
	print "count\tpercentage\n";
	$nids=$#ids;#print "$nids\n";				#number of promoter IDs
	foreach $key(keys %data)
	{	chomp $data{$key};
		$noVAL = () = $data{$key} =~ /0/g;
		$COUNT=$nids-$noVAL;	$PERC=($COUNT/$nids)*100;
		print "$data{$key}\t$COUNT\t$PERC\n";
	}
