infoData = getMetadata("Info");

i0 = indexOf(infoData, "\nUnits = ");
	if (i0==-1) exit ("Scale information not found");

i1 = indexOf(infoData, "=", i0);
i2 = indexOf(infoData, "\n", i1);
	if (i1==-1 || i2==-1)
   		exit ("Parsing error! Maybe the file structure changed?");

unit = substring(infoData,i1+2,i2);

// reciprocal nm as nm^{-1}
if( startsWith(unit,'1/') ) {
	recChar = fromCharCode(0x207b)+fromCharCode(0xb9);
	unit = substring(unit, 2, 4) + recChar;
}

getVoxelSize(pixelSize, dum1, dum2, dum3);
setVoxelSize(pixelSize, pixelSize, 1, unit);

hlim = Property.getNumber("HighLimit");
llim = Property.getNumber("LowLimit");
setMinAndMax(llim, hlim);

savePath = getInfo("image.directory") + "cal_" + getTitle();
savePath = replace(savePath, ".dm4", ".tif");
savePath = replace(savePath, "\\", "/");
//run("Bio-Formats Exporter", "save=["+savePath+"] compression=LZW");
saveAs("tiff", savePath);
close();
open(savePath);
exit();
