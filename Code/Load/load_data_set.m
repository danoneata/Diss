function [X, c] = load_data_set(name)

  full_name = [name '.mat'];
  data = load(full_name);
  
  X = data.X;
  c = data.c;

end