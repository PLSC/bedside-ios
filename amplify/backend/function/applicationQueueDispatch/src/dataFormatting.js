const dataForge = require("data-forge");
require("data-forge-fs");

/**
 * @param env the current env. currently restricted to dev or prod
 * @param id the user's id (for navigating to their user page)
 */
function createUrlWithId(env = process.env.ENV, id) {
  const baseUrl =
    env === "dev"
      ? "https://develop.simpl-bedside.org"
      : "https://www.simpl-bedside.org";
  return baseUrl + "/users/view/" + id;
}

/**
 * @param queryResults CSV formatted string from the query
 * defined in weeklyProcessTrigger/src/admin-email-weekly-query
 * @return JSON object representing all the program admin recipients
 * and the data that belongs in their report email.
 */
const formatReportData = (queryResults) => {
  const dataFrame = dataForge.fromCSV(queryResults);
  const series = dataFrame.groupBy((row) => row.recipient_email);

  var all_emails = [];

  //For each recipient in the query, create an object.
  for (group of series) {
    const one_week_ago = new Date();
    one_week_ago.setDate(new Date().getDate() - 7);
    const first = group.first();
    const email_data = {
      recipient_email: first.recipient_email,
      recipient_firstname: first.recipient_firstname,
      recipient_lastname: first.recipient_lastname,
      program_name: first.program_name,
      total_evals: group.count(),
      one_week_ago: one_week_ago.toLocaleDateString(),
      programs: [],
    };
    const program_group = group
      .orderBy((row) => row.program_name)
      .groupBy((row) => row.program_name);

    //For each program, create an object with the program name and a list of trainees.
    for (program of program_group) {
      const program_data = {
        program_name: program.first().program_name,
        trainees: [],
      };

      const trainee_group = group
        .orderBy((row) => row.trainee_lastname)
        .groupBy((row) => row.userid);

      //For each trainee, create an object with the trainee information and their evaluations.
      for (trainee of trainee_group) {
        const trainee_url = createUrlWithId(
          process.env.ENV,
          trainee.first().userid
        );

        const entry = {
          trainee_firstname: trainee.first().trainee_firstname,
          trainee_lastname: trainee.first().trainee_lastname,
          trainee_email: trainee.first().trainee_email,
          trainee_id: trainee.first().userid,
          trainee_url,
          procedures: [],
        };

        //Order the procedures by name, and add them to the trainee object.
        const procedures = trainee
          .orderBy((row) => row.procedure_name)
          .groupBy((row) => row.procedure_id);

        for (proc of procedures) {
          entry.procedures.push({
            procedure_name: proc.first().procedure_name,
            procedure_id: proc.first().procedure_id,
            total_procs: proc.count(),
            practice_ready_procs: proc
              .filter((row) => row.ratinglevel >= 4)
              .count(),
          });
        }
        program_data.trainees.push(entry);
      }
      email_data.programs.push(program_data);
    }

    all_emails.push(email_data);
  }

  return all_emails;
};

exports.formatReportData = formatReportData;
