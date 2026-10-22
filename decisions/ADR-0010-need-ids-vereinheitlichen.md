# ADR-0010: Stakeholder-Need-IDs vereinheitlichen

- Status: Vorgeschlagen
- Datum: 2026-10-22
- Betroffen: Kapitel 4 (Stakeholder Needs), Source-Felder in
  `sysml/baseline_a1/02_requirements.sysml`, generierte Traceability-Matrizen

## Kontext

Kapitel 4 fuehrt zwei Need-Listen nebeneinander:

- **Initiale Needs** SN-001 bis SN-010, mit Prioritaet (Must/Should).
- **Detaillierte Needs aus Iteration A** mit Fachpraefix (SN-USER-, SN-TRN-,
  SN-NAV-, SN-SAFE-, SN-OPS-, SN-MNT-, SN-DEV-, SN-EDU-, SN-UI-, SN-ENE-),
  ohne Prioritaet. Laut Kapitel 4 "ergaenzen" sie die initiale Liste.

Tatsaechlich sind 9 der 10 initialen Needs inhaltlich in der detaillierten Liste
enthalten, drei davon woertlich. Die Requirements verweisen mal auf das eine,
mal auf das andere Schema. Folge: Ob ein Need abgedeckt ist, haengt davon ab,
unter welcher ID man nachsieht. Beispiel: SN-005 (Diagnose) ist durch
REQ-DIAG-001 abgedeckt, sein Nachfolger SN-MNT-001 durch nichts.

## Zuordnung alt -> neu

| Alt | Prioritaet | Nachfolger | Bewertung |
| --- | --- | --- | --- |
| SN-001 | Must | SN-USER-001 | inhaltsgleich |
| SN-002 | Must | SN-TRN-001 | inhaltsgleich, neu ohne "Kiste" |
| SN-003 | Must | SN-OPS-001 | nahezu woertlich |
| SN-004 | Must | SN-SAFE-001 | woertlich |
| SN-005 | Should | SN-MNT-001 | inhaltsgleich |
| SN-006 | Must | SN-NAV-002, SN-NAV-003 | aufgeteilt |
| SN-007 | Should | **keiner** | IT-Sicherheit fehlt in der detaillierten Liste |
| SN-008 | Must | SN-DEV-003 | inhaltsgleich, neu auch STK-010 |
| SN-009 | Must | SN-EDU-001 | woertlich |
| SN-010 | Should | SN-EDU-002 | woertlich |

## Betrachtete Alternativen

1. **Beide Schemata behalten.** Abgelehnt: Die Doppelung erzeugt schon jetzt
   falsche Luecken und falsche Abdeckung.
2. **Nur SN-001 bis SN-010 behalten.** Abgelehnt: Die Liste ist zu grob. Tueren,
   Flur, Werkstuecktraeger-Uebergabe und Energie fehlen ganz.
3. **Nur die detaillierte Liste behalten, alte IDs als abgeloest fuehren.**

## Vorschlag

Alternative 3.

1. Die detaillierte Liste ist die einzige gueltige Need-Liste.
2. Die Tabelle SN-001 bis SN-010 bleibt in Kapitel 4 stehen, wird aber zu
   "Initiale Needs (abgeloest)" mit einer Spalte "Abgeloest durch". So bleiben
   alte Verweise in Protokollen und Vorversionen aufloesbar.
3. Fuer SN-007 wird ein neues Need **SN-IT-001** (Quelle STK-007) angelegt:
   "Netzwerkschnittstellen, Updates und Datenhaltung sollen kontrollierbar und
   sicher sein."
4. Die detaillierten Tabellen bekommen eine Spalte Prioritaet. Nachfolger
   uebernehmen die Prioritaet ihres Vorgaengers. Fuer die uebrigen 22 Needs
   legt das Projektteam die Prioritaet fest.
5. In den Source-Feldern der Requirements werden alte IDs durch die
   Nachfolger ersetzt. Der Generator meldet danach jede alte ID als Fehler.

## Auswirkung auf die Abdeckung

Heute haben 15 von 42 Need-IDs keine Anforderung. Nach der Vereinheitlichung
sind es 10 Needs: SN-USER-001, SN-MNT-001 und SN-NAV-003 erben die Verknuepfung
ihres Vorgaengers (SN-001 -> REQ-MIS-001, SN-005 -> REQ-DIAG-001,
SN-006 -> REQ-MAP-002). Fuer SN-NAV-003 passt REQ-NAV-002 fachlich besser und
sollte zusaetzlich verknuepft werden.

Von den 10 sind 3 nur nicht verknuepft, die passende Anforderung existiert
schon:

| Need | Passende Anforderung | Massnahme |
| --- | --- | --- |
| SN-NAV-001 (Ziele selbststaendig erreichen) | REQ-NAV-001 | Source ergaenzen |
| SN-OPS-002 (Stoerungen nachvollziehbar) | REQ-DIAG-001 | Source ergaenzen |
| SN-EDU-003 (ein Unterrichtsblock) | REQ-PWR-002 | Source ergaenzen |

Ein Need ist nur in Iteration B abgedeckt:

| Need | Anforderung |
| --- | --- |
| SN-TRN-004 (Mensch setzt Werkstuecktraeger auf) | REQ-B-TRN-001 |

Sechs Needs haben keine Anforderung. Das sind die eigentlichen Luecken:

| Need | Einschaetzung |
| --- | --- |
| SN-IT-001 (IT-Sicherheit, vorher SN-007) | Anforderung in Iteration C noetig; betrifft Web-App und Updates |
| SN-EDU-001 (Demonstration im Unterricht) | Projektzweck; ohne Anforderung nicht pruefbar |
| SN-EDU-002 (Zustaende nachvollziehbar darstellen) | teilweise REQ-STA-001; Darstellung fuer Lernende fehlt |
| SN-TRN-003 (Traeger dem Auftrag zuordnen) | Anforderung oder bewusster Verzicht fuer MVP 1 |
| SN-TRN-005 (Uebergabe durch Transfersystem) | Zielsystem, IF-004; Anforderung spaeter |
| SN-OPS-003 (wenig manuelle Eingriffe) | braucht Kennzahl; steht in Kapitel 5 als offene Quantifizierung "Verfuegbarkeit" |

## Folgeschritt (optional)

Die Needs liegen bisher nur im LaTeX. Der Generator kann deshalb nicht
pruefen, ob jedes Need abgedeckt ist. Zwei Wege:

- Needs als eigenes Paket ins SysML-Modell, Kapitel 4 wird daraus erzeugt.
  Das widerspricht der Regel "LaTeX zuerst" in `sysml/README.md` und muesste
  bewusst entschieden werden.
- Der Generator liest die Need-Tabellen aus Kapitel 4. Das haelt die Regel
  ein, macht den Generator aber vom Tabellenformat in LaTeX abhaengig.

## Ebenfalls gefunden, nicht Teil dieser Entscheidung

Der Begriff "Kiste" bzw. "Materialkiste" widerspricht DEC-003
(Werkstuecktraeger). Kapitel 5 ist korrigiert. Offen sind:

- Kapitel 1, Zeile 5 (Projektziel)
- Kapitel 4: STK-002, SN-002, SN-TRN-002, SN-TRN-003
- Kapitel 7: MVP-Abgrenzung ("Kistenaufnahme", "Kistenuebergabe")
- Kapitel 8: FUN-TRN-001 und TransportSystem

Kapitel 3, Zeile 156 ("abgestellte Kisten") meint Hindernisse und ist korrekt.
