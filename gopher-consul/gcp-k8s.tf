# resource "google_project_iam_member" "workload_identity-role" {
#   role   = "roles/iam.workloadIdentityUser"
#   member = "serviceAccount:${var.project}.svc.id.goog[workload-identity-test/workload-identity-user]"
# }