FROM perl:5.28

RUN apt-get update && apt-get install -y zip && \
    cpanm Carton Perl::Build JSON::XS

RUN perl-build 5.28.0 /opt/perl/

COPY cpanfile .
RUN carton install && carton install --deployment

COPY script/export-layers /export-layers
COPY script/bootstrap /opt/bootstrap
RUN chmod +x /export-layers /opt/bootstrap

CMD ["/export-layers"]
