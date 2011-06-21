for i in {2..13}
do
  matlab -nosplash -nodesktop -r "try_nca('wine',$i); quit;" 
done

for i in {2..4}
do
  matlab -nosplash -nodesktop -r "try_nca('iris',$i); quit;" 
done

for i in {2..7}
do
  matlab -nosplash -nodesktop -r "try_nca('ecoli',$i); quit;" 
done

for i in {2..7}
do
  matlab -nosplash -nodesktop -r "try_nca('glass',$i); quit;" 
done

for i in {2..33}
do
  matlab -nosplash -nodesktop -r "try_nca('ionosphere',$i); quit;" 
done

for i in {2..36}
do
  matlab -nosplash -nodesktop -r "try_nca('landsat',$i); quit;" 
done

for i in {2..8}
do
  matlab -nosplash -nodesktop -r "try_nca('pima',$i); quit;" 
done

for i in {2..18}
do
  matlab -nosplash -nodesktop -r "try_nca('segment',$i); quit;" 
done

for i in {2..44}
do
  matlab -nosplash -nodesktop -r "try_nca('spectf',$i); quit;" 
done

for i in {2..4}
do
  matlab -nosplash -nodesktop -r "try_nca('transfusion',$i); quit;"
done

for i in {2..8}
do
  matlab -nosplash -nodesktop -r "try_nca('yeast',$i); quit;"
done







