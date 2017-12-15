% bellekdeki de�erler ve ekran temizlenir.
  clear; clc; 

% g�sterilen konumda ki resmi imread metodu ile okuyarak goruntu de�i�kenine aktar�l�r.
  goruntu=imread('tire.tif');

% e�er g�r�nt�m�z renkli ise gri formata �evrilir. 
  if(size(goruntu,3)>1)
  goruntu=rgb2gray(goruntu);
  end

% local histogram yap�labilece�imiz pencere de�erlerimiz tan�mlan�r.
  pencere_satir=5;
  pencere_sutun=5;

% giri� resminin satir ve sutun de�erleri satir ve sutun de�i�kenlerine atan�r.
  [satir,sutun]=size(goruntu); 

% toplam pixel sayisi hesaplanarak toplam_pixel de�i�kenine aktar�l�r.
  toplam_pixel=satir*sutun; 

% giri� g�r�nt�s�n�n boyutlar� kadar yeni g�r�nt� i�in Sk255 matrisi olu�turulur.
  sk255=uint8(zeros(satir,sutun)); 

% giri� g�r�nt�s�n�n histogram de�erleri i�in histogram vekt�r� olu�turulur.
  giris_resmi_histogram=zeros(256,1);

%penceremizin ortadaki de�erleri t�m resim taranarak histogram vekt�r� olu�turulur.
for i=1:satir-(pencere_satir+1)/2-1
	for j=1:sutun-(pencere_sutun+1)/2-1
			
		%penceremizin orta noktas�n� bularak k de�i�kenine aktar�r.
		k=goruntu(ceil((i+(satir-1))/2),ceil(((j+sutun-1))/2))+1;

		%bu her k de�eri ka� tane ise histogram vekt�r�nde t�m resim taranarak tespit edilir.
		%bu sayede hangi pixel de�erinden ka� tane oldu�u tespit edilerek histogram vekt�r�ne aktar�l�r.
		giris_resmi_histogram(k+1)=(giris_resmi_histogram(k+1)+1);
	end
end

%k�m�latif histogram� yani pr ve sk hesab� a�a��daki i�lemler ile yap�l�r.
t=zeros(1,256);
for i=1:256
	%her renk de�erinin bulunma olas���� pr vekt�r�ne y�klenir
	kumulatif_olasilik_pr(i)=giris_resmi_histogram(i)/toplam_pixel;
	if(i==1)
	t(i)=t(i)+kumulatif_olasilik_pr(i);
	end
	if(i>1)		
	t(i)=t(i-1)+kumulatif_olasilik_pr(i);	
	end
	sk255(i)=round(t(i)*255);	
end

%ger�ek g�r�nt� de�erleri ��k�� g�r�nt� matrisine y�klenir
for i=1:satir
	for j=1:sutun
		cikis_goruntu(i,j)=sk255(goruntu(i,j)+1);
	end
end

% �lk resmimiz ve histogram�
  figure,imshow(goruntu);
  figure,imhist(goruntu);

% imhist metodu kullanmadan ��k�� g�r�nt�s�n�n histogram� hesaplan�r.
  cikis_goruntu_histogram=zeros(1,256);
for i=1:satir
	for j=1:sutun
		%cikis goruntusunun pencerede ki orta de�erlerinin adeti histogram vekt�r�ne aktar�l�r.
		k=cikis_goruntu(ceil((i+satir-1)/2),ceil((j+sutun-1)/2))+1;
		cikis_goruntu_histogram(k)=(cikis_goruntu_histogram(k)+1);
	end
end

% �ikis resmimizin histogram�
figure,imshow(cikis_goruntu);
x=(0:1:255);
figure,bar(x,cikis_goruntu_histogram);
axis([0 256 0 900]);