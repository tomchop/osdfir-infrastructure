{{/*
Init Container for when a Timesketch pod starts. To prevent duplicate code,
this file has been created which then applies to both the Timesketch Web and
Worker pod upon startup.
*/}}
{{- define "timesketch.initContainer" -}}
{{- $userconfigs := .Files.Glob .Values.config.override }}
- name: init-timesketch
  image: alpine/git
  command: ['sh', '-c', '/init/init-timesketch.sh']
  env:
    - name: TIMESKETCH_SECRET
      valueFrom:
        secretKeyRef:
          name: {{ include "timesketch.fullname" . }}-secret 
          key: timesketch-secret
    {{- if and .Values.redis.enabled .Values.redis.auth.enabled }}
    - name: REDIS_PASSWORD
      valueFrom:
        # Referencing from charts/redis/templates/_helpers.tpl
        secretKeyRef:
          name: {{ include "redis.secretName" .Subcharts.redis }}
          key: {{ include "redis.secretPasswordKey" .Subcharts.redis }}
    {{- end }}
    {{- if .Values.postgresql.enabled }}
    - name: POSTGRES_PASSWORD
      valueFrom:
        # Referencing from charts/postgresql/templates/_helpers.tpl
        secretKeyRef:
          name: {{ include "postgresql.v1.secretName" .Subcharts.postgresql }}
          key: {{ include "postgresql.v1.adminPasswordKey" .Subcharts.postgresql }}
    {{- end }}
  volumeMounts:
    - mountPath: /init
      name: init-timesketch
    - mountPath: /etc/timesketch
      name: timesketch-configs
    {{- if $userconfigs }}
    - mountPath: /tmp/timesketch
      name: uploaded-configs
    {{- end }}
{{- end }}
