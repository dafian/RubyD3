# Documentation for AreaChart(AxisComponent)  
Per praticità scrivo la documentazione usando come esempio il file area.rb in `examples\7_pv_d3examples\area\.`  
Prima riga `$:.unshift(File.dirname(__FILE__)+"/../../../lib")` carica il path da cui prendere la libreria; attenzione però al fatto che il path cambia a seconda di dove si trova il file che stai creando rispetto alla libreria Rubyvis. Quindi `require 'rubyvis'` carica il file ruby necessario per poter usare la libreria. Sottolineo il fatto che entrambe i comandi sono necessari. Quindi è possibile caricare i dati o inserirli in qualsiasi struttura dati.  
Successivamente vengono settati delle costanti che verranno utilizzate rispettivamente per la larghezza(w), altezza(h) e “shifting”(p) del pannello principale sulla quale costruiremo il nostro grafico.  Per quanto riguarda lo “shifting” questo non è altro che un valore che verrà utilizzato per dare un certo distacco del pannello dai margini della pagina.  
Ora settiamo i domini del nostro pannello rispettivamente per l’asse delle ascisse e per le ordinate, ovvero prendiamo come esempio l’ascissa. Ci dice che i valori assumeranno valori compresi tra 0 e 1 estremi compresi che verranno interpolati come grandezze sul grafico che andranno da 0(l’estremo sinistro del panel) a w(quello che sarà l’estremo destro del panel). Una nota particolare per il dominio dell’asse delle y in cui si può notare che h si trova prima dello 0, questo perché SVG ha  l’origine degli assi in alto a sinistra e l’asse delle ordinate si sviluppa verso il basso(ovviamente le ascisse si muovono normalmente verso destra), quindi utilizzando una scale da 0 a 1 avremo 0 come primo valore che coincide con l’origine del nostro grafico e deve essere nel punto più basso del pannello ovvero ad altezza h così poi da avere tutti i valori che crescono sull’asse delle y sempre più vicini al punto 0,0 in alto a sinistra.  
Ora iniziamo a costruire realmente il nostro grafico. Per prima cosa `vis = pv.Panel.new() do` ci permette di inizializzare il nostro pannello e di seguito vengono settati gli attributi: che faranno parte del tag <svg>.  
Poi troviamo l’inizializzazione di “group” che corrisponde al tag <g> del linguaggio SVG con un attributo transform=translate che trasla tutto ciò che è all’interno di questo tag.  
Quindi un altro group che presenta un attributo class che non è altro che un nome identificativo e un attributo data che ha come argomento x.ticks(10), ovvero è un array di dati formato da 10 ticks sugli assi più uno per ogni asse per l’orgine. Quando è presente l’attributo data con dimensione n vengono creati n oggetti di quel tipo(compreso i figli) dove ognuno usa un valore dell’array di dati.  
In group troveremo 4 oggetti: 2 rule e 2 label. Le rule non sono altro che le linee del piano cartesiano ed ognuno ha presente i suoi attributi. L’unico particolare per la rule è l’uso della variabile d per esempio in `stroke {|d| d==0 ? "#000" : "#eee"}` dove quel d sarà il dato ereditato dal group al livello immediatamente precedente(o se fosse stato settato l’array data in rule sarebbe stato uno dei suoi valori). Per quanto riguarda i due label essi corrispondono ai valori sugli assi, uno per l’asse delle x e uno per l’asse delle y e gli attributi sono stati opportunamente settati.  
Adesso troviamo l’area che ci permette di visualizzare l’area del nostro grafico. I campo data è settato con i dati citati all’inizio, in questo caso però non vengono create 20 istanze di data ma una sola perché area, line e panel producono un solo output unificato; poi y0 è il limite inferiore massimo su cui “si poggia” la nostra area, x e y1 invece creano proprio l’area a seconda di quello che sono i nostri dati costituiti da valori compresi tra 0 e 1 e che quindi vengono interpolati nei valori del codominio, per esempio tramite la funzione x.scale(d.x) per l’asse delle x; infine riempie l’area con il colore “lightsteelblue”.  
Dopo l’area troviamo la linea che verrà visualizzata su di essa e di questa è possibile intuire la costruzione delle coordinate che sono utilizzate perché la line è quasi una parte dell’area dove manca però il valore del limite inferiore dell’area. Inoltre è necessario settare il fill a “none” per un corretto utilizzo della line.  
Infine troviamo dot che va a formare gli oggetti circle dell’ immagine. Anche qui troviamo una grande somiglianza con un altro oggetto, ovvero la line, proprio perché i vari circle si poggiano proprio su di essa e poi vediamo settati gli attributi. Qui troviamo l'attributo shape_radius che non è altro che il raggio dei dot che però verrà visualizzato nel file SVG come l'attributo r delle forme circle, questo per dire che ci sono alcuni attributi che potrebbero avere dei nomi diversi da quelli che verranno visualizzati nell'SVG finale. Alla fine di questa documentazione verrà spiegato come provvedere a questo problema.  
Adesso abbiamo creato tutto il nostro grafico come una struttura dati in Ruby, ma che non è ancora pronta per essere visualizzata. Quindi è necessario fare la chiamata `vis.render()` che costruisce una struttura definitiva degli elementi della scena.  
A questo punto abbiamo quasi finito, manca l’ultimo passo ovvero la lettura di questi elementi della scena e la stampa su file. Come si può intuire f corrisponde allo stream su file e la chiamata `vis.to_svg` non fa altro che leggere gli elementi della scena per stampare tutte le linee di codice del file SVG risultante, che troveremo nel path indicato in apertura dello streaming.


### Come gestire gli Attributi degli Oggetti del Panel  
E’ possibile settare altri attributi, che potrebbero non essere stati previsti da Rubyvis, agli oggetti utilizzati in questa libreria. Per esempio se volessimo settare un attributo “qwerty”(è solo un esempio, l’attributo deve essere previsto dall’SVG) per un oggetto di tipo dot, è sufficiente aggiungere in rubyvis\lib\scene\svg_dot.rb nella struttura dati  
&nbsp;&nbsp;&nbsp;&nbsp;svg = {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"class" => s.classdot,     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"shape-rendering"=> s.shape_rendering,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"pointer-events"=> s.events,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"cursor"=> s.cursor,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"fill"=> s.fill,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"fill-opacity"=> s.fill_opacity,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"stroke"=> s.stroke,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"stroke-opacity"=> s.stroke_opacity,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"stroke-width"=> s.stroke_width  
&nbsp;&nbsp;&nbsp;&nbsp;}  
la stringa `“qwerty”=> s.qwerty` per esempio nell’ultima riga(se non fosse l’ultima riga è necessario aggiungere la virgola alla fine della stringa), poi aggiungere in `rubyvis\lib\mark\dot.rb` nella lista degli `attr_accessor_dsl` l’attributo `:qwerty` e farlo anche nel file `rubyvis\lib\sceneelement.rb` nella lista degli attributi `attr_accessor`. Ora è sufficiente scrivere in costruzione dell’oggetto dot l’attributo qwerty “VALORE” ad esempio  
&nbsp;&nbsp;&nbsp;&nbsp;dot do  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;data data  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;shape_radius(3.5)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cx {|d| x.scale(d.x)}  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cy {|d| y.scale(d.y)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fill "#fff"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stroke "steelblue"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;classdot("area")  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;qwerty “VALORE”  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stroke_width "1.5px"  
&nbsp;&nbsp;&nbsp;&nbsp;end  
ed il gioco è fatto!  
Ovviamente sarebbe meglio prima di creare l'attributo per l'oggetto object controllare nel rispettivo file `svg_object.rb` se nella sezione citata prima se fosse già possibile utilizzare tale attributo ma che è settato sotto altro nome come abbiamo visto per l'attributo shape_radius dell'oggetto dot.