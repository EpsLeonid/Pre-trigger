function make_adc_data()

a=zeros(43000,1);

a(:,1)=mod(1:43000,256);
%a(:,2)=a(:,1)+128;

for ch=1:16
    b=a+(ch-1)*256;
    fd=fopen(sprintf('adc_ch%d.txt',ch),'w');
    fprintf(fd,'%d\n',b');
    fclose(fd);
    fd=fopen(sprintf('adc_ch%d.txt',ch+16),'w');
    fprintf(fd,'%d\n',b');
    fclose(fd);
end
