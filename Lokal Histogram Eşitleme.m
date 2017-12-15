% bellekdeki deðerler ve ekran temizlenir.
  clear; clc; 

% gösterilen konumda ki resmi imread metodu ile okuyarak goruntu deðiþkenine aktarýlýr.
  goruntu=imread('tire.tif');

% eðer görüntümüz renkli ise gri formata çevrilir. 
  if(size(goruntu,3)>1)
  goruntu=rgb2gray(goruntu);
  end

% local histogram yapýlabileceðimiz pencere deðerlerimiz tanýmlanýr.
  pencere_satir=5;
  pencere_sutun=5;

% giriþ resminin satir ve sutun deðerleri satir ve sutun deðiþkenlerine atanýr.
  [satir,sutun]=size(goruntu); 

% toplam pixel sayisi hesaplanarak toplam_pixel deðiþkenine aktarýlýr.
  toplam_pixel=satir*sutun; 

% giriþ görüntüsünün boyutlarý kadar yeni görüntü için Sk255 matrisi oluþturulur.
  sk255=uint8(zeros(satir,sutun)); 

% giriþ görüntüsünün histogram deðerleri için histogram vektörü oluþturulur.
  giris_resmi_histogram=zeros(256,1);

%penceremizin ortadaki deðerleri tüm resim taranarak histogram vektörü oluþturulur.
for i=1:satir-(pencere_satir+1)/2-1
	for j=1:sutun-(pencere_sutun+1)/2-1
			
		%penceremizin orta noktasýný bularak k deðiþkenine aktarýr.
		k=goruntu(ceil((i+(satir-1))/2),ceil(((j+sutun-1))/2))+1;

		%bu her k deðeri kaç tane ise histogram vektöründe tüm resim taranarak tespit edilir.
		%bu sayede hangi pixel deðerinden kaç tane olduðu tespit edilerek histogram vektörüne aktarýlýr.
		giris_resmi_histogram(k+1)=(giris_resmi_histogram(k+1)+1);
	end
end

%kümülatif histogramý yani pr ve sk hesabý aþaðýdaki iþlemler ile yapýlýr.
t=zeros(1,256);
for i=1:256
	%her renk deðerinin bulunma olasýýðý pr vektörüne yüklenir
	kumulatif_olasilik_pr(i)=giris_resmi_histogram(i)/toplam_pixel;
	if(i==1)
	t(i)=t(i)+kumulatif_olasilik_pr(i);
	end
	if(i>1)		
	t(i)=t(i-1)+kumulatif_olasilik_pr(i);	
	end
	sk255(i)=round(t(i)*255);	
end

%gerçek görüntü deðerleri çýkýþ görüntü matrisine yüklenir
for i=1:satir
	for j=1:sutun
		cikis_goruntu(i,j)=sk255(goruntu(i,j)+1);
	end
end

% Ýlk resmimiz ve histogramý
  figure,imshow(goruntu);
  figure,imhist(goruntu);

% imhist metodu kullanmadan çýkýþ görüntüsünün histogramý hesaplanýr.
  cikis_goruntu_histogram=zeros(1,256);
for i=1:satir
	for j=1:sutun
		%cikis goruntusunun pencerede ki orta deðerlerinin adeti histogram vektörüne aktarýlýr.
		k=cikis_goruntu(ceil((i+satir-1)/2),ceil((j+sutun-1)/2))+1;
		cikis_goruntu_histogram(k)=(cikis_goruntu_histogram(k)+1);
	end
end

% Çikis resmimizin histogramý
figure,imshow(cikis_goruntu);
x=(0:1:255);
figure,bar(x,cikis_goruntu_histogram);
axis([0 256 0 900]);