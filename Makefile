## This is on_linelist
## Created by Dubzee 2021 Nov 17 (Wed) to link iPhis data

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Ignore += local.mk
username=username_required
-include local.mk

######################################################################

Ignore += *.stamp
IPHIS%.stamp:
	rsync $(username)@ms.mcmaster.ca:~/../g_earn_canmod/sfts.health.gov.on.ca-nightly-download/archive/2021-11-16/IPHIS_REPORT.CSV.gz .
	touch $@

Ignore += IPHIS_REPORT.CSV
IPHIS_REPORT.CSV: IPHIS00.stamp
	gunzip IPHIS_REPORT.CSV.gz
	touch $@

COVAX%.stamp:
	rsync $(username)@ms.mcmaster.ca:~/../g_earn_canmod/sfts.health.gov.on.ca-nightly-download/archive/2021-11-16/COVAX_File.zip .
	touch $@

Ignore += COVAX_File.csv COVAX_File.zip
COVAX_File.csv: COVAX00.stamp
	jar xvf COVAX_File.zip
	touch $@

Ignore += COVAX.random.csv
COVAX.random.csv: COVAX_File.csv Makefile
	head -1 $< > $@
	shuf -n 10000 $< >> $@

Ignore += COVAX.head.csv
COVAX.head.csv: COVAX_File.csv
	head -1000 $< > $@

Ignore += COVAX.wc
COVAX.wc: COVAX_File.csv
	 wc $< > $@

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

## -include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
