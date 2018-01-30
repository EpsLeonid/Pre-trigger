#include <string>
#include <sstream>
#include <TFile.h>
#include <TH1.h>
#include <TH2.h>
#include <TTree.h>
#include <iostream>
#include <string>
#include "TH2F.h"
#include <TROOT.h>
#include "TStyle.h"
#include <iostream>
#include <fstream>
#include <TProfile.h>
#include "TCanvas.h"
#include <TH1F.h>
#include <TF1.h>
#include "TMath.h" 
#include <TH2D.h>

void  for_leonid()
{

gROOT->Reset();


   ifstream inf1;
   inf1.open("/mnt/spool/Cmd3/1.txt", std::ios::in);


 Int_t EV_MAX = 11988;
 Float_t val_read;
 Float_t val[EV_MAX];
 TH1F *h_val = new TH1F("h_val","h_val",60, 120., 150.);



 unsigned int pcount1 = 0;

 
  while (1) {
      inf1 >> val_read;
      if (!inf1.good()) break;
      val[pcount1] = val_read;
      pcount1++;
   }
 
    inf1.close();



 for(unsigned int j = 0; j < Int_t(EV_MAX); j++){

//        printf("%.3f\n", val[j]);
        h_val->Fill(val[j]);
        h_val->GetXaxis()->SetTitle("value");
        
	}


h_val->Draw();


}
