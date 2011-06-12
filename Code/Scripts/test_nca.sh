matlab -nosplash -nodesktop -r "test_nca('wine',2,'pca',1); quit;" 
matlab -nosplash -nodesktop -r "test_nca('wine',2,'rand',1,100); quit;" &

matlab -nosplash -nodesktop -r "test_nca('iris',2,'pca',1); quit;" 
matlab -nosplash -nodesktop -r "test_nca('iris',2,'rand',1,100); quit;" &

matlab -nosplash -nodesktop -r "test_nca('landsat_train',2,'pca',10); quit;" 
matlab -nosplash -nodesktop -r "test_nca('landsat_train',2,'rand',10,100); quit;" &

matlab -nosplash -nodesktop -r "test_nca('pima',2,'pca',1); quit;" 
matlab -nosplash -nodesktop -r "test_nca('pima',2,'rand',1,100); quit;" &

matlab -nosplash -nodesktop -r "test_nca('olivetti-0.25',2,'pca',1); quit;" 
matlab -nosplash -nodesktop -r "test_nca('olivetti-0.25',2,'rand',1,100); quit;" &

matlab -nosplash -nodesktop -r "test_nca('segment',2,'pca',5); quit;" 
matlab -nosplash -nodesktop -r "test_nca('segment',2,'rand',5,100); quit;" &
