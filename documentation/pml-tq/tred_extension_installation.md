# PML Tree Query interface for TrEd installation
## Linux

``` bash
# installing system libraries
sudo apt-get install libx11-dev libxft-dev libfontconfig1-dev libpng12-dev zlib1g-dev libxml2-dev
# downloading TrEd
wget "http://ufal.mff.cuni.cz/tred/install_tred.bash"
# setting CPAN local
echo -ne "\n\n\n" | perl -MCPAN -e shell
# if you have configured cpan before tis command you should reconfigure it with
## echo -ne "o conf init\n\n\n" | perl -MCPAN -e shell
# setting environment variables
. ~/.bashrc
# Installing Mojo::Base::XS module (needed by PMLTQ)
cpan Mojo::Base::XS
# Installing TrEd
bash install_tred.bash --tred-dir ~/tred
# Start TrEd
~/tred/bin/start_tred
```
### Extension installation
1. Add PML Tree Query Interface for TrEd

  a. `Setup >> Manage Extensions >> Get New Extensions`

  b. Select the PML-TQ extension
  
  c. `Install selected`
  
  d. Close Manage Extensions window (Installation will start after that)
  
5. Run PML-TQ: `Macros >> Tree_Query >> *Start Tree Query`

## Mac OS
## Windows
Following tutorial has been tested on windows 7 and windows 10:

1. Download TrEd with included Strawberry perl ([download page](http://ufal.mff.cuni.cz/tred/))
2. Run installation

  a. install Strawberry perl to `C:\strawberry`

  b. change TrEd installation directory to `C:\tred`
3. Run TrEd
4. Add PML Tree Query Interface for TrEd

  a. `Setup >> Manage Extensions >> Get New Extensions`

  b. Select the PML-TQ extension
  
  c. `Install selected`
  
  d. Close Manage Extensions window (Installation will start after that)
  
  e. Installation will not be succesfull
  
  f. Close TrEd
  
  g. Run TrEd
  
  h. Setup >> Manage Extensions
  
  i. Enable PML Tree Query Interface for TrEd
  
  j. Close Manage Extensions window (Installation of missing modules will start after that)
5. Run PML-TQ: `Macros >> Tree_Query >> *Start Tree Query`

## Links
