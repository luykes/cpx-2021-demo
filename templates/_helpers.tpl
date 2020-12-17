{{/*
Expand the name of the chart.
*/}}
{{- define "cpx-helm-vulnerable.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cpx-helm-vulnerable.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cpx-helm-vulnerable.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cpx-helm-vulnerable.labels" -}}
helm.sh/chart: {{ include "cpx-helm-vulnerable.chart" . }}
{{ include "cpx-helm-vulnerable.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cpx-helm-vulnerable.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cpx-helm-vulnerable.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "metasploit-client.labels" -}}
client: metasploit
purpose: demo
{{- end}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cpx-helm-vulnerable.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cpx-helm-vulnerable.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
