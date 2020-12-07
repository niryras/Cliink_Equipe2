class dimension_df(object):
    def __init__(self,df):
        self.df = df
        
    def _analyse(self):
        print("Le jeu de données recense", 
              self.df.iloc[:-1].shape[0],
              "catégories pour les", 
              self.df.iloc[:,1:].shape[1], 
              "villes de l'agglomération")

