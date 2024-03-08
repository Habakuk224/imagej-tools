macro "Annotate Image" {

dir = getInfo("image.directory");
act_win = getTitle();
selectWindow(act_win);

getDimensions(width, height, channels, slices, frames);
getPixelSize(unit, pixelSize, pixelHeight);
sizeParam = width/1024;

defaultScalebar = 200*pixelSize*sizeParam;
sb_pwr = floor(log(defaultScalebar)/log(10))
defaultScalebar_rounded = round(defaultScalebar/pow(10,sb_pwr))*pow(10,sb_pwr);

or_tri_type = newArray("none", "cubic", "hex", "ortho", "tetra");
col_num = newArray("2", "1");

setBatchMode(1);

Dialog.create("Annotate");
  Dialog.addRadioButtonGroup("Columns", col_num, 1, 2, "2");

  Dialog.addMessage("Recommended:\n"+defaultScalebar+" for 2-cols\n"+defaultScalebar/2+" for 1-col");
  
  Dialog.addCheckbox("Add scalebar", true);
  Dialog.addNumber("Length:", defaultScalebar_rounded);
  
  Dialog.addCheckbox("Add upper left label", true);
  Dialog.addString("Text:", "");
  
  Dialog.addCheckbox("Add upper right label", false);
  Dialog.addString("Text:", "");
  
  Dialog.addRadioButtonGroup("Orientation triangle", or_tri_type, 3, 2, "none");

  Dialog.addCheckbox("Save after completion", true);
  Dialog.addCheckbox("Close after completion", false);
  
  Dialog.show();

  cols = parseInt(Dialog.getRadioButton());
  SB = Dialog.getCheckbox();
  SB_l = Dialog.getNumber();
  UL = Dialog.getCheckbox();
  UL_text = Dialog.getString();
  UR = Dialog.getCheckbox();
  UR_text = Dialog.getString();
  or_tri = Dialog.getRadioButton();
  file_save = Dialog.getCheckbox();
  file_close = Dialog.getCheckbox();

col_factor = cols/2;
SB_h = floor(12*sizeParam*col_factor);
SB_font = floor(48*sizeParam*col_factor);

if ((bitDepth() == 16) || (bitDepth() == 32)) {
	run("8-bit");
}

if (SB) {
	makeRectangle(0.02*width*col_factor, height-9.5*SB_h, 1, 1);
	SB_ls = String.format("%#1.0f", SB_l);
	SB_ldot = replace(SB_ls, ",", ".");
	run("Scale Bar...", "width="+SB_ldot+" height="+SB_h+" font="+SB_font+" color=Black background=White location=[At Selection] bold");	
}

if (UL) {
	
	setColor("black");
	setFont("SansSerif",SB_font,"bold antialiased");
	setJustification("center");

	drawString(" "+UL_text+" ", 0.05*width*col_factor, 1.5*SB_font, "white");
}

if (UR) {
	setColor("black");
	setFont("SansSerif",SB_font,"bold antialiased");
	setJustification("right");

	drawString(" "+UR_text+" ", (1-0.02*col_factor)*width, 1.5*SB_font, "white");
}

hex_w = 2047;
hex_h = 1358;

cubic_w = 2047;
cubic_h = 1999;

tetra_w = 2047;
tetra_h = 1689;

ortho_w = 2047;
ortho_h = 2123;

if (or_tri == "hex") {
	open(getDirectory("plugins") + "\\AnnoTools\\hex.png");
	selectWindow("hex.png");

	width_in = floor(240*sizeParam*col_factor);
	height_in = floor(240*sizeParam*hex_h/hex_w*col_factor);
	
	run("Size...", "width="+width_in+" height="+height_in+" average interpolation=Bicubic");
	run("Copy");
	selectWindow(act_win);
	makeRectangle(width-width_in, height-height_in, width_in, height_in);
	run("Paste");
	selectWindow("hex.png");
	close();
}

if (or_tri == "cubic") {
	open(getDirectory("plugins") + "\\AnnoTools\\cubic.png");
	selectWindow("cubic.png");

	width_in = floor(240*sizeParam*col_factor);
	height_in = floor(240*sizeParam*cubic_h/cubic_w*col_factor);
	
	run("Size...", "width="+width_in+" height="+height_in+" average interpolation=Bicubic");
	run("Copy");
	selectWindow(act_win);
	makeRectangle(width-width_in, height-height_in, width_in, height_in);
	run("Paste");
	selectWindow("cubic.png");
	close();
}

if (or_tri == "ortho") {
	open(getDirectory("plugins") + "\\AnnoTools\\ortho.png");
	selectWindow("ortho.png");

	width_in = floor(240*sizeParam*col_factor);
	height_in = floor(240*sizeParam*ortho_h/ortho_w*col_factor);
	
	run("Size...", "width="+width_in+" height="+height_in+" average interpolation=Bicubic");
	run("Copy");
	selectWindow(act_win);
	makeRectangle(width-width_in, height-height_in, width_in, height_in);
	run("Paste");
	selectWindow("ortho.png");
	close();
}

if (or_tri == "tetra") {
	open(getDirectory("plugins") + "\\AnnoTools\\tetra.png");
	selectWindow("tetra.png");

	width_in = floor(240*sizeParam*col_factor);
	height_in = floor(240*sizeParam*tetra_h/tetra_w*col_factor);
	
	run("Size...", "width="+width_in+" height="+height_in+" average interpolation=Bicubic");
	run("Copy");
	selectWindow(act_win);
	makeRectangle(width-width_in, height-height_in, width_in, height_in);
	run("Paste");
	selectWindow("tetra.png");
	close();
}

setBatchMode(0);

selectWindow(act_win);

if (file_save) {
	savePath = dir + replace(act_win, "-1.tif", ".tif");
	saveAs("png",savePath);
}

if (file_close) {
	close();
}

}