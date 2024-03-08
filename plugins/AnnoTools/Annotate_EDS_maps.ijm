macro "Annotate EDS maps" {

inputDir = getDir("Select directory with the EDS maps");
	fileList = getFileList(inputDir);
	imgList = Array.filter(fileList, "(_[A-Z][a-z]? ?[KLM].*png)" );
	
	for (i = 0; i < imgList.length; i++) {
		open(inputDir+imgList[i]);
		
		fname = File.nameWithoutExtension;
		spl = split(fname, "_");
		label = Array.filter(spl, "([A-Z][a-z]? ?[KLM])");
		lab_str = replace(label[0], " ", "");
		llen = lab_str.length();
		lab_str = substring(lab_str, 0, llen-1) + " " + substring(lab_str, llen-1, llen);
		
		csv = File.openAsString(inputDir+fname+".csv");
		
		i0 = indexOf(csv, "FieldWidth");
		if (i0==-1) exit ("Scale information not found");
		i1 = indexOf(csv, ":,", i0);
		i2 = indexOf(csv, ",", i1+2);		
		if (i1==-1 || i2==-1 || i2 <= i1+3)	exit ("Parsing error! Maybe the file structure changed?");
		text = substring(csv,i1+2,i2-1);
		fw = parseFloat(text);
		
		getDimensions(width, height, channels, slices, frames);
		sizeParam = width/1024;
		
		pixelSize = fw * 1e-3 / width;
		
		if (200*pixelSize*sizeParam < 1e-6)
			setVoxelSize(pixelSize*1e9, pixelSize*1e9, 1, "nm");
		else if (200*pixelSize*sizeParam < 1e-3)
			setVoxelSize(pixelSize*1e6, pixelSize*1e6, 1, "um");
		else
			setVoxelSize(pixelSize*1e3, pixelSize*1e3, 1, "mm");

		makeRectangle(0, 0, width, sizeParam*800);
		run("Crop");
		getDimensions(width, height, channels, slices, frames);

		if (i==0) {
			getPixelSize(unit, pixelSize, pixelHeight);
			defaultScalebar = 200*pixelSize*sizeParam;
			sb_pwr = floor(log(defaultScalebar)/log(10));
			defaultScalebar_rounded = round(defaultScalebar/pow(10,sb_pwr))*pow(10,sb_pwr);
		
			Dialog.create("Annotate");
  			Dialog.addMessage("Recommended:\n"+defaultScalebar+" for 2-cols");			
  			Dialog.addCheckbox("Add scalebar", false);
  			Dialog.addNumber("Length:", defaultScalebar_rounded);  
  			Dialog.addCheckbox("Add X-ray line label", true);
  			Dialog.addString("File prefix:", "prefix");
  			Dialog.show();

  			SB = Dialog.getCheckbox();
  			SB_l = Dialog.getNumber();
  			UR = Dialog.getCheckbox();
  			prefix = Dialog.getString();

			SB_h = floor(12*sizeParam);
			SB_font = floor(48*sizeParam);
		}
		
		if (SB) {
			makeRectangle(0.02*width, height-9.5*SB_h, 1, 1);
			SB_ls = String.format("%#1.0f", SB_l);
			SB_ldot = replace(SB_ls, ",", ".");
			run("Scale Bar...", "width="+SB_ldot+" height="+SB_h+" font="+SB_font+" color=Black background=White location=[At Selection] bold");	
		}
		
		if (UR) {
			setColor("black");
			setFont("SansSerif",SB_font,"bold antialiased");
			setJustification("right");

			drawString(" "+lab_str+" ", (1-0.02)*width, 1.5*SB_font, "white");
		}
		
		savePath = inputDir + prefix + "_" + replace(lab_str, " ", "");
		saveAs("png",savePath);
		saveAs("tiff",savePath);
		close();
	}
}