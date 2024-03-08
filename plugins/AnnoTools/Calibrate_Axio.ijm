macro "Calibrate Axio" {
//Gets the tag, and parses it to get the pixel size information
//AxioObserver
path = getInfo("image.directory") + getInfo("image.filename");

run("Bio-Formats Macro Extensions");
Ext.setId(path);
Ext.getPixelsPhysicalSizeX(pixelSize)

print(pixelSize);

getDimensions(width, height, channels, slices, frames);
sizeParam = width/1024;

if (200*pixelSize*sizeParam < 1000) {
	setVoxelSize(pixelSize, pixelSize, 1, "nm");
} else {
	if (200*pixelSize*sizeParam > 1e6)
		setVoxelSize(pixelSize*1e-6, pixelSize*1e-6, 1, "mm");
	else
		setVoxelSize(pixelSize*1e-3, pixelSize*1e-3, 1, "um");
}

savePath = getInfo("image.directory") + "cal_" + getInfo("image.filename");
savePath = replace(savePath, "\\", "/");

saveAs("tiff", savePath);
close();
open(savePath);
exit();
}