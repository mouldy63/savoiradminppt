function getMattressMadeAt(savoirmodel) {
	var mattressMadeAt = 0;
	if (savoirmodel=="No. 1" || savoirmodel=="No. 2"  || savoirmodel=="State") mattressMadeAt = 2; //2 is made at london
	if (savoirmodel=="No. 3" || savoirmodel=="No. 4") mattressMadeAt = 1; //1 is made at Cardiff
	//If savoirmodel!="No. 1" && savoirmodel!="No. 2"  && savoirmodel!="No. 3" && savoirmodel!="No. 4" then getMattressMadeAt = 1 '2 is made at london
	return mattressMadeAt;
}

function getBaseMadeAt(basesavoirmodel) {
	var baseMadeAt = 0;
	if (basesavoirmodel=="No. 1" || basesavoirmodel=="No. 2" || basesavoirmodel=="State" || basesavoirmodel=="Savoir Slim") baseMadeAt=2;
	if (basesavoirmodel=="No. 3" || basesavoirmodel=="No. 4")  baseMadeAt=1;
	return baseMadeAt;
}

function getTopperMadeAt(toppertype, savoirmodel, basesavoirmodel, mattressmadeat, basemadeat) {
	var topperMadeAt = 0;
	if (toppertype=="HCa Topper")  topperMadeAt=2;
	if (toppertype=="HW Topper" && (savoirmodel!="" && savoirmodel!="n"))  topperMadeAt=mattressmadeat;
	if (toppertype=="HW Topper" && (basesavoirmodel!="" && basesavoirmodel!="n"))  topperMadeAt=basemadeat;
	if (toppertype=="HW Topper" && (savoirmodel=="" || savoirmodel=="n")  && (basesavoirmodel=="" || basesavoirmodel=="n"))  topperMadeAt=1;
	if (toppertype=="CW Topper" && (savoirmodel!="" && savoirmodel!="n"))  topperMadeAt=mattressmadeat;
	if (toppertype=="CW Topper" && (basesavoirmodel!="" && basesavoirmodel!="n"))  topperMadeAt=basemadeat;
	if (toppertype=="CW Topper" && (savoirmodel=="" || savoirmodel=="n") && (basesavoirmodel=="" || basesavoirmodel=="n"))  topperMadeAt=1;
	if (topperMadeAt == "")  topperMadeAt = 0; // happens if theres no mattress or base in the order
	return topperMadeAt;
}

function getHeadboardMadeAt(aHeadboardstyle, basemadeat, mattressmadeat) {
	var headboardMadeAt = 0;
	var headcardiff = false;
	if (aHeadboardstyle=="C1" || aHeadboardstyle=="C2" || aHeadboardstyle=="C4" || aHeadboardstyle=="C5" || aHeadboardstyle=="C6" || aHeadboardstyle=="CF1" || aHeadboardstyle=="CF2" || aHeadboardstyle=="C4" || aHeadboardstyle=="C5")  headcardiff=true;
	if (headcardiff) {
		headboardMadeAt=1;
		if (headboardMadeAt!="" && basemadeat!="")  headboardMadeAt=basemadeat;
		if (headboardMadeAt!="" && mattressmadeat!="")  headboardMadeAt=mattressmadeat;
	} else {
		headboardMadeAt=2;
	}
	return headboardMadeAt;
}

function getValanceMadeAt() {
	return 2;
}

function getLegsMadeAt() {
	return 2;
}
