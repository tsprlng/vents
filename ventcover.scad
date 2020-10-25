// overall dimensions (mm)
depth=11;
outer=122;
thickness=2;  // thickness of frame

slatsCount=9;

// dimension of side holding-in blobs (mm)
blobProjection=2.2;
blobRadius=1.5;

// manual creation of supports for printing blobs (unused)
propThickness=0.8;

// smoothly curved slat shape (difference between two different-radiused cylinders, within the cross-section of the frame)
module slat(){
	rotate([0, 90, 0]){
		intersection(){
			translate([8, -1, 0]){ difference(){
				cylinder(
					h=outer,
					r=12,
					$fn = 100,
					center=true);
				translate([7, 6, 0])
					cylinder(
						h=outer,
						r=18,
						$fn = 100,
						center=true);
			}}
			cube([depth, depth, outer], center=true);
		}
	}
}

module vent(){
	// slats
	slatSpacing = (outer-thickness) / (slatsCount+1);
	for (slatNumber = [1:slatsCount]){
		translate([0, 0, (outer - 2*thickness)/2 - (slatNumber*slatSpacing)])
			slat();
	}
	
	// frame
	for (side = [0:90:270]) {
		rotate([0, side, 0])
			translate([(outer-thickness)/2, 0, 0])
				cube([thickness, depth, outer], center=true);
	}
	
	// vertical brace down the middle of the frame
	cube([thickness, depth, outer], center=true);
	
	// side blobs
	blobXOffset = (outer+blobProjection)/2;
	for (x = [-blobXOffset, blobXOffset]){
		for (z = [-(outer/6), outer/6]){
			// actual blob
			translate([x, depth/2-blobRadius, z])
				rotate([0, 90, 0])
				cylinder(
					h=blobProjection,
					r=blobRadius,
					$fn = 100,
					center=true);
		
			// manual creation of supports for printing blobs (unused)
			// translate([x, 0, z])
			// cube([blobProjection, depth, propThickness], center=true);
		}
	}
}

color("lightgrey")
translate([0, 0, depth/2])
rotate([90, 0, 0])
vent();
