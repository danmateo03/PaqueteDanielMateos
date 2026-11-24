#’ Cruzar ctgov.studies con ctgov.interventions para comparar el número de estudios
#' según el tipo de intervención (ClinicalTrials.gov)
#’
#' Recibe una patología como argumento.
#' Cruza ctgov.studies con ctgov.interventions.
#' Filtra los ensayos por patología.
#' Agrupa por tipo de intervención y fase.
#' Calcula el número de estudios y el reclutamiento medio.#’ @param patologia Texto de busqueda de la enfermedad (ej. "Melanoma").
#’
#’ @return dos columnas:
#' intervention_type: el tipo de intervención (DRUG, BIOLOGICAL, DEVICE, etc.)
#' num_ensayos: número de ensayos clínicos distintos para cada tipo de intervención
#’ @export
#’
#’ @examples
#’ \dontrun{
#’ aaa()
#’ }


nueva_funcion <- function(){

  usuario <- Sys.getenv("AACT_USER")
  clave <- Sys.getenv("AACT_PASSWORD")
  if (usuario == "" || clave == "") {
    stop("Configura AACT_USER y AACT_PASSWORD en tu archivo .Renviron.")
  }

  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = "aact",
    host = "aact-db.ctti-clinicaltrials.org",
    port = 5432,
    user = usuario,
    password = clave
  )
  on.exit(DBI::dbDisconnect(con), add = TRUE)

  aaa <- "SELECT
  i.intervention_type,
  COUNT(DISTINCT s.nct_id) AS num_ensayos
  FROM ctgov.studies s
  INNER JOIN ctgov.interventions i
  ON s.nct_id = i.nct_id
  INNER JOIN ctgov.conditions c
  ON s.nct_id = c.nct_id
  WHERE LOWER(c.name) LIKE LOWER('%Melanoma%')
  GROUP BY i.intervention_type
  ORDER BY num_ensayos DESC;"

  DBI::dbGetQuery(
    con,
    aaa)
}
