package math
{
	import coordinateReference.Axis;
	import coordinateReference.CRS;
	import coordinateReference.GeodeticDatum;
	
	import dataTypes.spatialGeometry.Coordinate2;
	import dataTypes.spatialGeometry.GeodeticCoordinate;
	import dataTypes.spatialGeometry.PlaneRectangularCoordinate;
	
	import math.Angle;
	import math.Hyperbolic;
	
	public class GaussKruger
	{
		private var a:Number; 			//length of semi-major axis
		private var rf:Number;			// reverse flattening 
		private var m0:Number;			// scale factor at the prime meridian of coordinate system 
		private var phi0rad:Number;		// origin latitude  in radian
		private var lmbd0rad:Number;	// origin longitude in radian
		
		private var n:Number;
		private var n15:Number; 
		private var anh:Number; 
		private var nsq:Number;
		private var e2n:Number; 
		private var ra:Number;
		private var jt:int; 
		private var jt2:int;
		private var ep:Number; 
		private var e:Array;
		private var s:Array;
		private var t:Array; 
		private var alp:Array;
		private var beta:Array;
		private var dlt:Array;
		
		private var eastNorth:Boolean;
		private var falseEasting:Number;
		private var falseNorthing:Number;
		
		public function GaussKruger()
		{
		}
		
		public function setParameters(crs:CRS):void {
			a = crs.datum.ellips.semiMajorAxis;
			rf = crs.datum.ellips.inverseFlattening;
			m0 = crs.cs.ps.scaleFactor;
			var ogn:Coordinate2 = crs.cs.ps.origin;
			phi0rad = math.Angle.decimalToRad(ogn.x);	// origin latitude
			lmbd0rad = math.Angle.decimalToRad(ogn.y);	// origin longitude
			 
			n	= 0.5/(rf-0.5);
			n15 = 1.5*n; 
			anh	= 0.5*a/(1+n); 
			nsq	= n*n;
			e2n	= 2.*Math.sqrt(n)/(1.+n); 
			ra	= 2*anh*m0*(1+nsq/4+nsq*nsq/64);
			jt	= 5; 
			jt2	= 2*jt;
			ep	= 1.0; 
			e	= new Array();
			s	= new Array();
			t	= new Array(); 
			alp = new Array();
			beta= new Array();
			dlt	= new Array();
			
			// north-east or east-north
			eastNorth = false;
			if (crs.cs.id.search("(E, N)") != -1) eastNorth = true;	
			
			// offset
			var i:int = 0;
			while(i < crs.cs.axis.length) {
				var ax:Axis = crs.cs.axis.getItemAt(i) as Axis;
				falseEasting  = crs.cs.ps.falseEasting;
				falseNorthing = crs.cs.ps.falseNorthing;
				i++;
			}
			
		}
		
		private function Merid(B:Number):Number {
			/*
			B: latitude in radian
			Return: meridional parts to B from the equator
			
			The algorithm was originally provided by Bessel(1837) and Helmert(1880). 
			This is adopted in practice rule of Public Survay Specification provided 
			by Geospatial Information Authority of Japan (GSI) since 2011.
			*/
			var BesselS:Number =
				a*((315./512.)*n*n*n*n*Math.sin(8.*B)
				-(35./48.)*n*n*n*Math.sin(6.*B)
				+(15./16.)*(n*n-n*n*n*n/4.)*Math.sin(4.*B)
				-(3./2.)*(n-n*n*n/8.)*Math.sin(2.*B)
				+(1.+n*n/4.+n*n*n*n/64.)*B)/(1.+n);
			return BesselS;
		}
		
		public function BLtoXY(crd:Coordinate2):PlaneRectangularCoordinate {
			/*
			num: coordinate system number
			phi: latitude in radian (B:Breite)
			lmbd: longitude in radian (L:Länge）

			This algorithm was proposed by Kazushige KAWASE, 
			"Concise Derivation of Extensive Coordinate Conversion Formulae 
			in the Gauss-Krüger Projection", 2012
			http://www.gsi.go.jp/ENGLISH/Bulletin60.html
			
			This paper was written based on the paper by Hiroshi MASAHARU,
			"Re-evaluation of the first formula given in Krueger(1912) 
		 	for the Gauss-Krueger projection", 2008
		 	http://www2.jpgu.org/meeting/2008/program/pdf/J166/J166-P002_e.pdf
			This page is included in the Proceedings of Japan Geoscience Union Meeting 2008
			http://www2.jpgu.org/meeting/2008/index_e.htm
			*/
			
			var phirad:Number  = crd.x;
			var lmbdrad:Number = crd.y;
			
			for(var k:int = 1; k<=jt; k++) {
				e[k] = n15/k-n;
				ep*=e[k];
				e[k+jt]=n15/(k+jt)-n;
			}
			
			alp[1]=(1./2.+(-2./3.+(5./16.+(41./180.-127./288.*n)*n)*n)*n)*n;
			alp[2]=(13./48.+(-3./5.+(557./1440.+281./630.*n)*n)*n)*nsq;
			alp[3]=(61./240.+(-103./140.+15061./26880.*n)*n)*n*nsq;
			alp[4]=(49561./161280.-179./168.*n)*nsq*nsq;
			alp[5]=34729./80640.*n*nsq*nsq;

			var sphi:Number = Math.sin(phirad); 
			var nphi:Number = (1-n)/(1+n)*Math.tan(phirad);
			var dlmbd:Number = lmbdrad - lmbd0rad;
			var sdlmbd:Number = Math.sin(dlmbd);
			var cdlmbd:Number = Math.cos(dlmbd);
			var tchi:Number = Hyperbolic.sinh(Hyperbolic.arctanh(sphi)-e2n*Hyperbolic.arctanh(e2n*sphi));
			var cchi:Number = Math.sqrt(1.+tchi*tchi);
			var xip:Number = Math.atan2(tchi, cdlmbd);
			var xi:Number = xip;
			var etap:Number = Hyperbolic.arctanh(sdlmbd/cchi); 
			var eta:Number = etap; 
			var sgm:Number = 1.;
			var tau:Number = 0.;
			
			for(var j:int = alp.length; --j;) {
				var alsin:Number = alp[j]*Math.sin(2.*j*xip);
				var alcos:Number = alp[j]*Math.cos(2.*j*xip);
				xi += alsin*Hyperbolic.cosh(2.*j*etap);
				eta+= alcos*Hyperbolic.sinh(2.*j*etap);
				sgm+= 2.*j*alcos*Hyperbolic.cosh(2.*j*etap);
				tau+= 2.*j*alsin*Hyperbolic.sinh(2.*j*etap);
			}
			
			var md:Number = Merid(phi0rad);
			var prc:PlaneRectangularCoordinate = new PlaneRectangularCoordinate();
			prc.x = ra*xi-m0*md;
			prc.y = ra*eta;
			prc.gamma = Math.atan2(tau*cchi*cdlmbd+sgm*tchi*sdlmbd, sgm*cchi*cdlmbd-tau*tchi*sdlmbd);
			prc.m = ra/a*Math.sqrt((sgm*sgm+tau*tau)/(tchi*tchi+cdlmbd*cdlmbd)*(1.+nphi*nphi));
			
			//for UTM Coordinate
			if (eastNorth) {
				var w:Number = prc.y;
				prc.y = prc.x;
				prc.x = w;
				prc.x += falseEasting;
				prc.y += falseNorthing;
			}
			
			return prc;
		}
		
		public function XYtoBL(crd:Coordinate2):GeodeticCoordinate {
			/*
			num: coordinate system number
			x: vertical coordinate
			y: horizontal coordinate
			
			This algorithm was proposed by Kazushige KAWASE, 
			"Concise Derivation of Extensive Coordinate Conversion Formulae 
			in the Gauss-Krüger Projection", 2012
			http://www.gsi.go.jp/ENGLISH/Bulletin60.html
			
			This paper was written based on the paper by Hiroshi MASAHARU,
			"Re-evaluation of the first formula given in Krueger(1912) 
			for the Gauss-Krueger projection", 2008
			http://www2.jpgu.org/meeting/2008/program/pdf/J166/J166-P002_e.pdf
			This page is included in the Proceedings of Japan Geoscience Union Meeting 2008
			http://www2.jpgu.org/meeting/2008/index_e.htm
			*/
			
			var x:Number = crd.x;
			var y:Number = crd.y;
			
			// for UTM Coordinate
			if (eastNorth) {
				x -= falseEasting;
				y -= falseNorthing;
				var w:Number = x;
				x = y;
				y = w;
			}
			
			for(var k:int = 1; k<=jt; k++) {
				ep*=e[k]=n15/k-n; 
				e[k+jt]=n15/(k+jt)-n;
			}

			// 展開パラメータの事前入力
			beta[1]=(1./2.+(-2./3.+(37./96.+(-1./360.-81./512.*n)*n)*n)*n)*n;
			beta[2]=(1./48.+(1./15.+(-437./1440.+46./105.*n)*n)*n)*nsq;
			beta[3]=(17./480.+(-37./840.-209./4480.*n)*n)*n*nsq;
			beta[4]=(4397./161280.-11./504.*n)*nsq*nsq;
			beta[5]=4583./161280.*n*nsq*nsq;
				
			dlt[1]=(2.+(-2./3.+(-2.+(116./45.+(26./45.-2854./675.*n)*n)*n)*n)*n)*n;
			dlt[2]=(7./3.+(-8./5.+(-227./45.+(2704./315.+2323./945.*n)*n)*n)*n)*nsq;
			dlt[3]=(56./15.+(-136./35.+(-1262./105.+73814./2835.*n)*n)*n)*n*nsq;
			dlt[4]=(4279./630.+(-332./35.-399572./14175.*n)*n)*nsq*nsq;
			dlt[5]=(4174./315.-144838./6237.*n)*n*nsq*nsq;
			dlt[6]=601676./22275.*nsq*nsq*nsq;

			var xi:Number	= (x+m0*Merid(phi0rad))/ra;
			var xip:Number 	= xi;
			var eta:Number 	= y/ra; 
			var etap:Number = eta;
			var sgmp:Number = 1.; 
			var taup:Number = 0.;
			
			for(var j:int = beta.length - 1; j > 0; --j) {
				var besin:Number = beta[j]*Math.sin(2.*j*xi);
				var becos:Number = beta[j]*Math.cos(2.*j*xi)
				xip -= besin*Hyperbolic.cosh(2.*j*eta);
				etap-= becos*Hyperbolic.sinh(2.*j*eta);
				sgmp-= 2.*j*becos*Hyperbolic.cosh(2.*j*eta); 
				taup+= 2.*j*besin*Hyperbolic.sinh(2.*j*eta);
			}
			
			var sxip:Number		= Math.sin(xip);
			var cxip:Number 	= Math.cos(xip); 
			var shetap:Number 	= Hyperbolic.sinh(etap);
			var chetap:Number 	= Hyperbolic.cosh(etap);
			var chi:Number 		= Math.asin(sxip/chetap);
			var phi:Number 		= chi; 
			
			for(j = dlt.length - 1; j > 0; --j) {
				phi += dlt[j]*Math.sin(2.*j*chi);
			}
			
			var nphi:Number = (1.-n)/(1.+n)*Math.tan(phi);
			
			var lmbd:Number = lmbd0rad + Math.atan2(shetap, cxip);  //lmbd:radian. The original program gets lmbd in "second".
			var gmm:Number  = Math.atan2(taup*cxip*chetap+sgmp*sxip*shetap,sgmp*cxip*chetap-taup*sxip*shetap);
			var m:Number    = ra/a*Math.sqrt((cxip*cxip+shetap*shetap)/(sgmp*sgmp+taup*taup)*(1+nphi*nphi));
			
			var gc:GeodeticCoordinate = new GeodeticCoordinate();
			gc.lat 		= phi;		// lat/lon/gmm are returned as radian!
			gc.lon 		= lmbd;
			gc.gamma 	= gmm;
			gc.m 		= m;
			
			return gc;
		}
	}
}