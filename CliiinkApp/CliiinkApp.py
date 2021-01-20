#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    docstring for ClassName
"""
from flask import (
	Flask,
	g,
	redirect,
	render_template,
	request,
	session,
	url_for
)
import pandas as pd
import json
from sqlalchemy import create_engine
from main import Bin_, User
import plotly.express as px
import plotly.graph_objects as go

# On importe le fichier json pour rendre anonyme l'entrée de nos données personnelles
# On L'utilise lors de la connexion avec la base de données 
fichierConfig = "../data/config.json" 
with open(fichierConfig) as fichier:
    config = json.load(fichier)["mysql"]

# On assigne PassWord et UserName
PassWord = Bin_(config["password"])._UserP()
UserName = config["user_name"] #Bin_(config["user_name"])._UserP()

# On créer une liste utlisateur
users =[]
users.append(User(1, UserName, PassWord))
users.append(User(2,"Steph","3322"))
usersL = [i.username for i in users]

# Connection avec la base de donnée
engine = create_engine('mysql+' + config["connector"]
                        + '://' + config["user"] + ":" + PassWord + "@"
                        + config["host"] + ":" + config["port"] + "/" + config["bdd"]
                        )

# Configuration affichage des graphs
config_graphs = {'displayModeBar': False}


############################

### Fonctions DataFrames ###

############################


# Création du DataFrame population
_population = """SELECT * FROM population
	JOIN categorie_socio_pro
		ON population.po_csp_id_fk = categorie_socio_pro.csp_id
	JOIN ville
		ON population.po_vi_id_fk = ville.vi_id
	JOIN age
		ON age.ag_id = population.po_ag_id_fk
    WHERE csp_nom not in ('Total');"""
df_population = pd.read_sql(_population, engine)

# Création du DataFrame entreprise
_entreprise = """SELECT * FROM ville
	JOIN entreprise
		ON ville.vi_id = entreprise.en_vi_id_fk
	JOIN secteur_activite
		ON entreprise.en_sa_id_fk = secteur_activite.sa_id;"""
df_entreprise = pd.read_sql(_entreprise, engine)

# Création du DataFrame pop2
_pop2 = """SELECT SUM(po_nbre_pop) as nombre, csp_nom as csp, ag_tranche_age as age FROM population
	JOIN categorie_socio_pro
		ON population.po_csp_id_fk = categorie_socio_pro.csp_id
	JOIN age
		ON population.po_ag_id_fk = age.ag_id
	where csp_nom not in ('total')
	GROUP BY csp, age
	ORDER BY csp DESC, nombre ASC;"""
df_pop2 = pd.read_sql(_pop2, engine)

dfNouveau = df_population.groupby(by=["vi_nom", "ag_tranche_age"])["po_nbre_pop"].sum().reset_index(name="quantite")
df_en = df_entreprise.groupby(by=["sa_nom", "vi_nom"])["en_id"].count().reset_index(name="quantite")




def create_list(colonne1, colonne2, table):
    """
        Créer une liste qui nous permettras de faire les requetes.
        Utiliser coter html pour la séléction des arguments.
    """
    request_ = """SELECT %s FROM %s;"""
    request = pd.read_sql(request_%(colonne1,table), engine)
    liste_ville = [request.iloc[i][colonne2] for i in request.index]
    return liste_ville


def creat_df(date, ville):
    """
        Creer un DataFrame pour retourner le poids des recoltes par jours.
        Utiliser dans le Graph 4.
    """
    request_ = """SELECT date as date, SUM(poids) as poids, vi_nom as ville FROM collecte
    JOIN ville
        ON collecte.ville = ville.vi_id
    WHERE (YEAR(date) = %s) AND (vi_nom = %s) 
    GROUP BY date, vi_nom
    ORDER BY date;"""
    request = pd.read_sql(request_%(date, ville), engine)
    return request

def creat_df3(date, ville):
    """
        Creer un DataFrame pour retourner le detail des recoltes.
        Utiliser dans chart_lo_en pour le graph indicateur nombre total de collectes.
    """
    request_ = """SELECT date, poids, vi_nom as ville FROM collecte
    JOIN ville
        ON collecte.ville = ville.vi_id
    WHERE (YEAR(date) = %s) AND (vi_nom = %s);"""
    request = pd.read_sql(request_%(date, ville), engine)
    return request

def creat_df2(date, ville):
    """
        Creer un DataFrame pour retournée toutes les collectes éffectuer de l'année precedente.
        Utliser comme reference dans dans le graph indicateur nombre total de collectes.
    """
    request_ = """SELECT date, poids, vi_nom as ville FROM collecte
    JOIN ville
        ON collecte.ville = ville.vi_id
    WHERE (YEAR(date) = %s) AND (vi_nom = %s);"""
    request = pd.read_sql(request_%(int(date)-1 if isinstance(date, int) else 2017, ville), engine)
    return request

def creat_Nrefenrence(date, ville):
    """
        Créer un DataFrame de reference à l'année precedente pour le poids total des collectes.
        Utliser comme reference dans dans le graph_4.
        Et dans les graphs indicateur poids/ans par habitant et poids/ans par foyer.
    """
    request_ = """SELECT SUM(poids) as poids FROM collecte
    JOIN ville
        ON collecte.ville = ville.vi_id
    WHERE (YEAR(date) = %s) AND (vi_nom = %s);"""
    request = pd.read_sql(request_%(int(date)-1 if isinstance(date, int) else 2017, ville), engine)
    return request

def creat_df_entreprise(ville):
    """
        Créer un DataFrame qui reference toutes le entreprises.
        Utiliser dans creat_chart.
        Retourne un int.
    """
    request_ = """SELECT * FROM CLIIINK2.entreprise
        JOIN ville
            ON entreprise.en_vi_id_fk = ville.vi_id
        WHERE (vi_nom = %s);"""
    request = pd.read_sql(request_%(ville), engine)
    EN = request.en_id.count()
    return EN

def creat_df_population(ville):
    """
        Créer un DataFrame qui reference la population.
        Utlisier dans le graph indicateur comme reference.
        De l'année en cours et de la precedente.
    """
    request_ = """SELECT po_nbre_pop as quantite, vi_nom as ville, ag_tranche_age as tranche_age FROM population
        JOIN categorie_socio_pro
            ON population.po_csp_id_fk = categorie_socio_pro.csp_id
        JOIN ville
            ON population.po_vi_id_fk = ville.vi_id
        JOIN age
            ON age.ag_id = population.po_ag_id_fk
        WHERE (vi_nom = %s) AND (csp_nom = 'Total') ;"""
    request = pd.read_sql(request_%(ville), engine)
    return request


def creat_df_logement(ville):
    """
        Créer un DataFrame qui reference toutes les catégorie de logement.
        Utiliser dans le graph indicateur poids/ans par foyer.
        Utiliser comme reference de l'année en cours et de la precedente.
        Retourne un int.
    """
    request_ = """SELECT * FROM CLIIINK2.logement
        JOIN categorie_logement
            ON  logement.lo_cl_id_fk = categorie_logement.cl_id
        JOIN ville
            ON logement.lo_vi_id_fk = ville.vi_id
        WHERE (vi_nom = %s) AND (cl_nom NOT IN ('Total'));"""
    request = pd.read_sql(request_%(ville), engine)
    return request

def create_df_lo_en(NTL, EN):
    """
        Créer le DataFrame logement/entreprise pour le Pie Chart.
        Nécessite 2 int en arguments.
        retourne un DataFrame.
        Utiliser dans le graph creat_chart.
    """
    request = pd.DataFrame({'categorie':['Logement','Entreprise'], 'nombre':[NTL, EN]})
    return request


#def population(ville, population):
    """
        Créer le DataFrame population par ville avec le scatter.
        Nécessite 2 int en arguments.
        retourne un DataFrame.
        Utiliser dans le graph creat_chart.
    """
    #request = pd.read_sql(request_%(pop_poids_ville), engine)
    #return request

########################

### Fonctions Graphs ###

########################


# Diagramme à barre présentant le nombre d'habitants par tranche d'age par ville de l'agglomération
def create_graph1():
	fig2 = px.bar(dfNouveau, x="vi_nom", y="quantite",
		color='ag_tranche_age', title="Nombre d'habitants par tranche d'age par ville")
	fig2.write_html("static/img/jupyter-graph_2.html", config=config_graphs)


def create_graph2():	
	fig3 = px.funnel(df_pop2, x='nombre', y='csp', color='age')
	fig3 = fig3.update_yaxes(visible=False, showticklabels=False)
	fig3.write_html("static/img/jupyter-graph_3.html", config=config_graphs)

	
def create_graph3():
	labels = df_en["sa_nom"]
	values = df_en["quantite"]
	fig4 = go.Figure(data=[go.Pie(labels=labels, values=values, hole=.5)])
	fig4 = fig4.update_traces(textposition='inside', textfont_size=14)
	fig4 = fig4.update_layout(showlegend=False)
	fig4.write_html("static/img/jupyter-graph_4.html", config=config_graphs)


def creat_graph4(df, NDF):
    """
        Créer le graphique principale du tableau de bord.
        Nécessite un dataframe et un int en arguments.
        Retourne un fichier html qui contient le graph.
    """
    fig = go.Figure()
    # Graph bar moyenne par mois
    fig.add_trace(go.Histogram(x=df['date'],
                               y = df["poids"],
                               xbins=dict(size='M1'),
                               name='trace'
                              )
                 )

    # Fonction moyenne du graph bar
    fig = fig.update_traces(visible=True, histfunc="avg")

    # Fonction slide sur l'axe x
    fig.update_xaxes(
        rangeslider_visible=True,
        rangeselector=dict(
            buttons=list([            
                dict(step="all"),
                dict(count=1, label="1y", step="year", stepmode="backward"),
                dict(count=6, label="6m", step="month", stepmode="todate"),
                dict(count=1, label="1m", step="month", stepmode="backward"),
                dict(count=7, label="1w", step="day", stepmode="backward")
            ])
        )
    )

    # Graph ligne poids/jours
    fig.add_trace(go.Scatter(x=df['date'], y=df['poids'],
                             mode='lines', #+markers', (add markers)
                             name='lines'
                            )
                 )

    # Graph marqueur ajoutable avec la legende
    fig.add_trace(go.Scatter(x=df['date'], y=df['poids'],
                             mode='markers',# (add markers)
                             visible='legendonly', # option activation avec legende
                             name='markers',
                             marker_color='#330C73'
                            )
                 )

    # Moyenne poids par jour 
    MPJ = df.poids.sum()//365
    # Graph indicateur ajoutable avec la legende
    fig.add_trace(go.Indicator(
        title  =  { "text": """Moyenne par jour<br>
        <span style='font-size:1em;color:gray'>Réference de l'anneé précédente</span>""",
                    #"text" :  "Moyenne par jour",
                   "align":"right",
                   "font_family":" PT Sans Narrow "},
        mode = "number+delta",
        value = MPJ,
        number = {'suffix': "kg"},
        delta = {'relative':True, 'position': "top", 'reference': NDF},
        align = "right",
        domain = {'x': [1,0.95], 'y': [0.7, 1]}))

    # Option du Graph
    fig.update_layout(title = 'Poids collecté par jours',
                      xaxis_title = 'Date',
                      yaxis_title = 'Quantité en kilo',                  
                      bargap = 0.1,
                      paper_bgcolor = "lightgray")
                      

    fig.write_html("static/img/jupyter-graph_4.html", config=config_graphs)


def chart_indicator(PAH, PAHR, TCA, TCAR, PAL, PALR):
    """
        Créer le graphique secondaire du tableau de bord.
        Nécessite des nombres de type int en arguments.
        Retourne un fichier html qui contient le graph.
    """
    fig = go.Figure()

    # Ref: Poids/ans par habitant
    fig.add_trace(go.Indicator(
        title  =  { "text": """Poids/ans par habitant<br>
        <span style='font-size:0.6em;color:gray'>Réference de l'anneé précédente</span>""",
                   "align":"right",
                   "font_family":" PT Sans Narrow "},
        mode = "number+delta",
        value = PAH,
        number = {'suffix': "kg"},
        delta = {'relative':True, 'reference': PAHR},
        align = "left",
        domain = {'x': [0,0.25], 'y': [0, 1]}))


    # Ref: Nombre total collecte
    fig.add_trace(go.Indicator(
        title  =  { "text": """Nombre total collecte<br>
        <span style='font-size:0.6em;color:gray'>Réference de l'anneé précédente</span>""",
                   "align":"right",
                   "font_family":" PT Sans Narrow "},
        mode = "number+delta",
        value = TCA,
        delta = {'relative':True, 'reference': TCAR},
        align = "left",
        domain = {'x': [0.4,0.64], 'y': [0, 1]}))


    # Ref: Poids/ans par foyer
    fig.add_trace(go.Indicator(
        title  =  { "text": """Poids/ans par foyer<br>
        <span style='font-size:0.5em;color:gray'>Réference de l'anneé précédente</span>""",
                   "align":"right",
                   "font_family":" PT Sans Narrow "},
        mode = "number+delta",
        value = PAL,
        number = {'suffix': "kg"},
        delta = {'relative':True, 'reference': PALR},
        align = "left",
        domain = {'x': [0.75,1], 'y': [0, 1]}))

    # Option du Graph
    fig.update_layout(#paper_bgcolor = "lightgray",
    					paper_bgcolor='rgba(0,0,0,0)',
    					plot_bgcolor='rgba(0,0,0,0)',
    					#autosize=False,
    					#margin_autoexpand=False
    					)


    fig.write_html("static/img/jupyter-graph_6.html", config=config_graphs)


def creat_chart(lo_en, EN, NTL):
    """
        Créer le graphique Pie chart du tableau de bord.
        Nécessite un dataframe et deux int en arguments.
        Retourne un fichier html qui contient le graph.
    """
    fig = go.Figure(data=[go.Pie(labels=lo_en.categorie, values=lo_en.nombre, hole=.7)])
    fig = fig.update_traces(textposition='inside', textfont_size=14)
    

    fig.add_trace(go.Indicator(
        mode = "number",
        value = EN,
        delta = {'relative':False, 'reference': NTL},
        domain = {'x': [0.3,0.7], 'y': [0, 1]}))
    

    fig.update_layout(title = 'Taux entreprise/logement',

    				    #width=500,
    				    #height=500,
                      title_x=0.5,
                      title_y=0.85,
                      font=dict(size=15),
                      paper_bgcolor='rgba(0,0,0,0)',
                      plot_bgcolor='rgba(0,0,0,0)',                      
                      legend = dict(
									orientation="h",
									yanchor="bottom",
									x=0.1,
									y=-0.4,
									bgcolor="rgba(0,0,0,0)",
									font = dict(
									          #size=10,
									          )
									)#,showlegend=False
						)  

        
    fig.write_html("static/img/jupyter-graph_5.html", config=config_graphs)


app = Flask(__name__)
app.secret_key = 'somescretkeythatonlyishouldknow'

@app.before_request
def before_request():
	g.user = None

	if 'user_id' in session:
		user = [x for x in users if x.id == session['user_id']][0]
		g.user = user


@app.route("/")
def home():
	create_graph1()
	create_graph2()
	create_graph3()
	return render_template('index.html')


@app.route("/login", methods=['GET', 'POST'])
def login():
	if request.method == 'POST':

		session.pop("user_id", None)
		username = request.form['username']
		password = request.form['password']

		if username not in usersL:
			return redirect(url_for('login'))

		user = [x for x in users if x.username == username][0]
		if user and user.password == password:
			session["user_id"] = user.id
			return redirect(url_for('profile'))

		return redirect(url_for('login'))

	return render_template("CliiinkLogin.html")


@app.route("/charts")
def charts():
	return render_template('charts.html')

@app.route("/profile")
def profile():
    if not g.user:
        return redirect(url_for('login'))
    villes = create_list('vi_nom', 'vi_nom', 'ville')
    dates = create_list('DISTINCT(YEAR(date)) AS date', 'date', 'collecte')
    date_ = " OR YEAR(date)= ".join(str(date) for date in dates)
    ville = "'{}'".format(request.args.get('ville', "'OR vi_nom='".join(villes)))
    ville1 = "{}".format(request.args.get('ville', "Total"))
    date = request.args.get('date', 2020)
    df = creat_df(date, ville)
    population = creat_df_population(ville)
    df2 = creat_df2(date, ville)
    df3 = creat_df3(date, ville)
    EN = creat_df_entreprise(ville)
    NTL_ = creat_df_logement(ville)
    NTL = NTL_.lo_nbre.astype(int).sum()
    df_lo_en = create_df_lo_en(NTL, EN)
    creat_chart(df_lo_en, EN, NTL)
    # ici on indique le poids total de précédante
    reference_ = creat_Nrefenrence(date, ville)
    #PTR = reference_.poids[0].astype(int)
    
    PTR = (reference_.poids[0].astype(int) if isinstance(reference_.poids[0], float) else 0)
    
    # ici on indique le ratio par jour de réference de l'année précendante
    ndf = int(PTR//365)
    # ici on indique le poids total de l'année en cours
    PT = df.poids.sum()
    # ici on indique moyenne poids par jour collect
    MPJ = df.poids.sum()//365
    # ici on indique le nombre total d'habitant
    NTH = population.quantite.sum()
    # Ici on indique le poids/ans par habitant de l'année en cours
    PAH = (PT//NTH if (PT != 0) & (NTH != 0) else 0)
    # Ici on indique le poids/ans par habitant de l'année precedente
    PAHR = (PTR//NTH if (PTR != 0) & (NTH != 0) else 0)
    # Ici on indique le poids/ans par foyer de l'année en cours
    PAL = PT//NTL
    # Ici on indique le poids/ans par foyer de l'année precedente
    PALR = PTR//NTL
    # Ici on indique le nombre de collecte total de l'année en cours
    TCA = df3.poids.count()
    # Ici on indique le nombre de collecte total de l'année precedente
    TCAR = df2.poids.count()
    creat_graph4(df, ndf)
    chart_indicator(PAH, PAHR, TCA, TCAR, PAL, PALR)
    #import random
    #nombre = str(random.randint(100000,99999999))
    return render_template('profile.html', villes=villes, dates=dates, date_=date_, ville1=ville1)

if __name__ == "__main__":
	app.run(debug=True)