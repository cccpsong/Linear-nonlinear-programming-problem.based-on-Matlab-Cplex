{string} Products = ...;
{string} Components = ...;

float demand[Products][Components] = ...;
float Profit[Products] = ...;
float Stock[Components] = ...;
dvar float+ Production[Products];

maximize
  sum( p in Products ) 
    Profit[p] * Production[p];
    
subject to {
  forall( c in Components )
    ct:
      sum( p in Products ) 
        demand[p,c] * Production[p] <= Stock[c];
};