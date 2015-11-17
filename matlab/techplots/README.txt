Matlab instructions

To generate the techplots_114.sw0 file:
1. tcsh #If default shell is bash do this
2. source /usr/class/ee114/hspice/DOT.cshrc
3. hspice techplots_114.sp

Matlab:
1. Add path: /usr/class/ee214/matlab/hspice_toolbox
2. tech_data = loadsig("techplots_114.sw0")
3. lssig(tech_data)
4. ngmid = evalsig(tech_data, 'ngmid')
5. ngmro = evalsig(tech_data, 'ngmro')
6. plot(ngmid, ngmro)

The signals you really care about:
ngmid, ngmro, nidw, nft
pgmid, pgmro, pidw, pft