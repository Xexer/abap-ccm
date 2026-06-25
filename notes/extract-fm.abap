FUNCTION z_ca_atc_level_a_objects
  EXPORTING
    VALUE(objects) TYPE i.

  CONSTANTS abap_cloud  TYPE char1      VALUE '5'.
  CONSTANTS active_flag TYPE string     VALUE 'A'.
  CONSTANTS version     TYPE decfloat16 VALUE '0000'.

  DATA name_filter TYPE RANGE OF char50.

  name_filter = VALUE #( sign   = 'I'
                         option = 'CP'
                         ( low = 'Y*' )
                         ( low = 'Z*' ) ).

  " Open: DEVC (TDEVC with DLVUNIT LIKE 'Z%'), MSAG (T100A no Language)

  SELECT FROM progdir " CLAS, INTF, PROG, BDEF
    FIELDS COUNT( * ) AS customer_objects
    WHERE     name    IN @name_filter
          AND state    = @active_flag
          AND uccheck  = @abap_cloud
    INTO @DATA(number_of_objects).
  objects += number_of_objects.

  SELECT FROM dd02l " TABL
    FIELDS COUNT( * ) AS customer_objects
    WHERE     tabname               IN @name_filter
          AND as4local               = @active_flag
          AND as4vers                = @version
          AND abap_language_version  = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dd12l " XINX
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND as4vers               = @version
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dd40l " TTYP
    FIELDS COUNT( * ) AS customer_objects
    WHERE     typename              IN @name_filter
          AND as4local               = @active_flag
          AND abap_language_version  = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dd04l " DTEL
    FIELDS COUNT( * ) AS customer_objects
    WHERE     rollname              IN @name_filter
          AND as4local               = @active_flag
          AND as4vers                = @version
          AND abap_language_version  = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dd01l " DOMA
    FIELDS COUNT( * ) AS customer_objects
    WHERE     domname               IN @name_filter
          AND as4local               = @active_flag
          AND as4vers                = @version
          AND abap_language_version  = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ddddlsrc " DDLS
    FIELDS COUNT( * ) AS customer_objects
    WHERE     ddlname               IN @name_filter
          AND as4local               = @active_flag
          AND abap_language_version  = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dddrty_source " DRTY
    FIELDS COUNT( * ) AS customer_objects
    WHERE     type_name             IN @name_filter
          AND as4local               = @active_flag
          AND abap_language_version  = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ddlxsrc " DDLX
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dddras_source " DRAS
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dddsfd_source " DSFD
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dddsfi_source " DSFI
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dddteb_header " DTEB
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dd25l " ENQU
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND as4vers               = @version
          AND aggtype               = 'E'
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ina1_header " INA1
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM balobj " APLO
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM datefunction " DTFD
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM apj_w_jce_root " SAJC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM apj_w_jt_root " SAJT
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM authx_attr " SU20
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM tobj_attr " SU21
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM usob_sm " SU22
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM aps_oda_w_pack " SOD1
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM aps_oda_package_assignment_api " SOD2
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM arch_obj " AOBJ
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ars_w_api_cat " APIC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM acmdclsrc " DCLS
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM amc_appl " SAMC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM apc_appl " SAPC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM sql1_head " SQL1
    FIELDS COUNT( * ) AS customer_objects
    WHERE     state                 = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srvdsrc " SRVD
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM o2xsltdesc " XSLT
    FIELDS COUNT( * ) AS customer_objects
    WHERE     state                 = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM bgqc_service " BGQC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM cfd_w_badi " CFDA
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM cdb_objh " CDBO
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM tcdrp " CHDO
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM tmc1 " VKOI
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM t681 " VKOS
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM objh " TOBJ
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM dddtdc_source " DTDC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     as4local              = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM abap_daemon_dt " DMON
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edccontype " EDCC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edcconcheck " EDCK
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edcreptype " EDCR
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edointerface " EDOI
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edomsgtype " EDOM
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edoprocess " EDOP
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM edotype " EDOT
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM enhheader " ENHO
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM enhspotheader " ENHS
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM evtb_header " EVTB
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM fdt_trans_ato_00 " FDT3
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM gsm_md_prv_w " GSMP
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM arc_destr_obj " DOBJ
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM lrm_t_ot " ILMB
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM islm_modelcc " INTM
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM islm_ps " INTS
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ktd_w_header " SKTD
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /uif/lrepdcont " LREP
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM smbc_config " SMBC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM smimloio " SMIM
    FIELDS COUNT( * ) AS customer_objects
    WHERE prop01 = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM smtr_project " TRPR
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM nont_header " NONT
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM tnro " NROB
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ntebasic_as " NTTA
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ntebasic_type " NTTY
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM o2appl " WAPA
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM oa2_sd_sc " OA2S
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM pcf_w_node " PCFN
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM ront_header " RONT
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM rsm_cntxt_extn_w " RMCE
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM rsm_cfg_cntxt " RMCT
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM rsm_rule_w " RMRL
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM rsm_teamcatg_s " RMTC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM rvb_def " RVBC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM chkc_header " CHKC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM chke_header " CHKE
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM chko_header " CHKO
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM chkv_header " CHKV
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM sch_mdl_mde " ESH3
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM sit2_bt " SITB
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM sit2_ct " SITC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM sit2_object " SITO
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM smtg_tmpl_hdr " SMTG
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srf_app " SRFA
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srf_cfg_par " SRFP
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srf_rep_cat " SRFQ
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srf_report " SRFR
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srf_schema " SRFS
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srvb_head " SRVB
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM srvc_head " SRVC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM sui_tm_mm_app " UIAD
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM uconhttpservhead " HTTP
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM wdy_config_data " WDCC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM wmpc_dt " WMPC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     version               = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /aif/icd_data " AIFC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /aif/icd_data_e " AIFE
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwbep/i_cp_mod " GCPM
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwbep/i_mgw_ohd " IWMO
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwfnd/i_med_ohd " IWOM
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwfnd/i_med_srh " IWSG
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwbep/i_mgw_srh " IWSV
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwbep/i_mgw_vah " IWVB
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwbep/i_v4_msgr " G4BA
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwbep/i_v4_msrv " G4BS
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwxbe/i_cons " EEEC
    FIELDS COUNT( * ) AS customer_objects
    WHERE     state                 = @active_flag
          AND abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /iwxbe/i_prod " EEEP
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /ssb/sacda_s " DAQR
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.

  SELECT FROM /ssb/sacstory_s " STYC
    FIELDS COUNT( * ) AS customer_objects
    WHERE abap_language_version = @abap_cloud
    INTO @number_of_objects.
  objects += number_of_objects.
ENDFUNCTION.