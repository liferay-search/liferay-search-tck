#!/bin/bash

set -o errexit ; set -o nounset

RUN_ALL_TESTS=${RUN_ALL_TESTS:=true}
OPEN_TEST_REPORTS_IN_BROWSER=${OPEN_TEST_REPORTS_IN_BROWSER:=false}
APP_SERVER_PARENT_DIR=${APP_SERVER_PARENT_DIR:=""}
RECREATE_COMPONENT_CONFIGURATIONS=${RECREATE_COMPONENT_CONFIGURATIONS:=false}
RECREATE_LOG4J_CONFIGURATIONS=${RECREATE_LOG4J_CONFIGURATIONS:=false}
COMMAND_RUN_SOME_TESTS=${COMMAND_RUN_SOME_TESTS:=""}



#
# SEE: https://github.com/liferay/liferay-portal/blob/972f280bde2e2c69027588eb553b065a59eef3b4/test.properties#L1812-L1843
#
function run_all_tests()
{
# portal-search-test

test_run portal-search/portal-search-test \
	*Test \
; \

# Highest coverage of Search (most critical first)

test_run change-tracking/change-tracking-test \
	*.search.*Test \
; \

test_run users-admin/users-admin-test \
	*.search.*Test \
	com.liferay.users.admin.indexer.test.*Test \
; \

test_run dynamic-data-mapping/dynamic-data-mapping-test \
	*.search.*Test \
	com.liferay.dynamic.data.mapping.exportimport.data.handler.test.DDMFormAdminPortletDataHandlerTest \
	com.liferay.dynamic.data.mapping.exportimport.data.handler.test.DDMFormDisplayPortletDataHandlerTest \
	com.liferay.dynamic.data.mapping.exportimport.data.handler.test.DDMFormInstanceRecordStagedModelDataHandlerTest \
	com.liferay.dynamic.data.mapping.exportimport.test.DDMFormDisplayExportImportTest \
	com.liferay.dynamic.data.mapping.expression.test.DDMExpressionFunctionTrackerTest \
	com.liferay.dynamic.data.mapping.internal.exportimport.content.processor.test.DDMFormValuesExportImportContentProcessorTest \
	com.liferay.dynamic.data.mapping.internal.security.permission.resource.test.DDMFormInstanceRecordModelResourcePermissionTest \
	com.liferay.dynamic.data.mapping.service.test.*Test \
	com.liferay.dynamic.data.mapping.staging.test.DDMFormInstanceStagingTest \
	com.liferay.dynamic.data.mapping.storage.test.StorageAdapterTest \
	com.liferay.dynamic.data.mapping.test.DDMStructureManagerTest \
	com.liferay.dynamic.data.mapping.upgrade.v2_0_3.test.UpgradeDDMFormInstanceSettingsTest \
; \

test_run document-library/document-library-test \
	*.search.*Test \
	com.liferay.document.library.app.service.test.DLAppServiceWhenSearchingFileEntriesTest \
	com.liferay.document.library.trash.test.DLFileEntryTrashHandlerTest \
	com.liferay.document.library.trash.test.DLFolderTrashHandlerTest \
; \

test_run journal/journal-test \
	*.search.*Test \
	com.liferay.journal.asset.test.JournalArticleAssetSearchTest \
	com.liferay.journal.service.test.JournalArticleExpirationTest \
	com.liferay.journal.service.test.JournalArticleIndexVersionsTest \
	com.liferay.journal.service.test.JournalArticleScheduledTest \
	com.liferay.journal.trash.test.JournalArticleTrashHandlerTest \
	com.liferay.journal.trash.test.JournalFolderTrashHandlerTest \
; \

test_run headless/headless-delivery/headless-delivery-test \
	com.liferay.headless.delivery.resource.v1_0.test.*Test \
; \

test_run headless/headless-admin-user/headless-admin-user-test \
	com.liferay.headless.admin.user.resource.v1_0.test.*Test \
; \

test_run headless/headless-admin-taxonomy/headless-admin-taxonomy-test \
	com.liferay.headless.admin.taxonomy.resource.v1_0.test.TaxonomyVocabularyResourceTest

# Highest coverage of Search, part 2 (alphabetical)

test_run asset/asset-test \
	*.search.*Test \
	com.liferay.asset.service.test.AssetVocabularyServiceTest \
	com.liferay.asset.util.test.AssetHelperTest \
; \

test_run asset/asset-categories-test \
	*.search.*Test \
; \

test_run blogs/blogs-test \
	*.search.*Test \
	com.liferay.blogs.asset.test.BlogsEntryAssetSearchTest \
	com.liferay.blogs.service.test.BlogsEntryStatusTransitionTest \
	com.liferay.blogs.service.test.BlogsEntryTrashHandlerTest

test_run calendar/calendar-test \
	*.search.*Test

test_run sharing/sharing-search-test \
	*Test

test_run user-groups-admin/user-groups-admin-web-test \
	*.search.*Test 

# All other tests using Search in some capacity (alphabetical)

test_run account/account-test \
	com.liferay.account.retriever.test.*Test \
	com.liferay.account.service.test.AccountEntryLocalServiceTest \
; \

test_run asset/asset-publisher-test \
	com.liferay.asset.publisher.lar.test.AssetPublisherExportImportTest

test_run bookmarks/bookmarks-test \
	*.search.*Test \
	com.liferay.bookmarks.service.test.BookmarksFolderServiceTest \
	com.liferay.bookmarks.trash.test.BookmarksEntryTrashHandlerTest \
	com.liferay.bookmarks.trash.test.BookmarksFolderTrashHandlerTest \
; \

test_run configuration-admin/configuration-admin-test \
	*.search.*Test

test_run data-engine/data-engine-rest-test \
	com.liferay.data.engine.rest.resource.v2_0.test.DataDefinitionResourceTest

test_run depot/depot-test \
	*.search.*Test \

test_run dynamic-data-lists/dynamic-data-lists-test \
	*.search.*Test

test_run layout/layout-test \
	com.liferay.layout.search.test.LayoutIndexerReindexTest \
	com.liferay.layout.search.test.LayoutRelevanceSearchTest \
; \

test_run message-boards/message-boards-test \
	*.search.*Test \
	com.liferay.message.boards.trash.test.MBThreadTrashHandlerTest

test_run organizations/organizations-test \
	*.search.*Test \
	com.liferay.organizations.service.test.OrganizationLocalServiceWhenSearchingOrganizationsTreeTest \
; \

test_run polls/polls-test \
	*.search.*Test \
; \

test_run portal-workflow/portal-workflow-kaleo-test \
	com.liferay.portal.workflow.kaleo.internal.runtime.integration.test.WorkflowTaskManagerImplTest

test_run redirect/redirect-test \
	*.search.*Test \
; \

test_run wiki/wiki-test \
	*.search.*Test \
	com.liferay.wiki.attachments.test.WikiAttachmentsTest \
	com.liferay.wiki.trash.test.WikiPageTrashHandlerTest \
; \

}

function run_some_tests()
{
#	

eval "$COMMAND_RUN_SOME_TESTS"

if [ 0 = true ]
then

# this test creates a DL file and never removes it -- search engine is polluted
test_run document-library/document-library-test \
	com.liferay.document.library.webdav.test.WebDAVLitmusBasicTest

#
:
fi

#
:	
}

function do_test_run()
{
	local directory=$1
	local no_settings_gradle=$2
	shift 2
	local tests=( "$@" ) 

	figlet -f digital RUN $directory || true

	if [ "$RECREATE_COMPONENT_CONFIGURATIONS" = true ]
	then
		if [ "$APP_SERVER_PARENT_DIR" ]
		then
			mkdir -p \
				$APP_SERVER_PARENT_DIR/osgi/configs/
			cp *.config \
				$APP_SERVER_PARENT_DIR/osgi/configs/
		fi
	fi

	if [ "$RECREATE_LOG4J_CONFIGURATIONS" = true ]
	then
		if [ "$APP_SERVER_PARENT_DIR" ]
		then
			mkdir -p \
				$APP_SERVER_PARENT_DIR/osgi/log4j/
			cp *-log4j-ext.xml \
				$APP_SERVER_PARENT_DIR/osgi/log4j/
		fi
	fi

	cd $directory

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle settings.gradle.ORIGINAL || true
		mv ../settings.gradle ../settings.gradle.ORIGINAL || true
	fi

	local gwtests=()
	for test in "${tests[@]}"; do
		gwtests+=("--tests")
		gwtests+=($test)
	done

	local arg__app_server_parent_dir=()

	if [ "$APP_SERVER_PARENT_DIR" = "" ]
	then
		arg__app_server_parent_dir=""		
	else
		arg__app_server_parent_dir="-Dapp.server.parent.dir=$APP_SERVER_PARENT_DIR"
	fi

	#
	# Environment variables
	# so we don't need to write to
	# portal-ext.properties 
	#
	# module.framework.properties.dependency.manager.sync.timeout=900
	export LIFERAY_MODULE_PERIOD_FRAMEWORK_PERIOD_PROPERTIES_PERIOD_DEPENDENCY_PERIOD_MANAGER_PERIOD_SYNC_PERIOD_TIMEOUT=900

	${LIFERAY_PORTAL_DIR}/gradlew cleanTestIntegration testIntegration --stacktrace \
		${arg__app_server_parent_dir} -Dorg.gradle.daemon=false -Dsetup.wizard.enabled=false \
		"${gwtests[@]}"

#	\
#	--quiet \
#	|| \
#	{ 
#		RETURN_CODE=$?
#		echo ${RETURN_CODE}
#		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
#	}

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle.ORIGINAL settings.gradle || true
		mv ../settings.gradle.ORIGINAL ../settings.gradle || true	
	fi

	if [ "$OPEN_TEST_REPORTS_IN_BROWSER" = true ]
	then
		open build/reports/tests/testIntegration/index.html || true
	fi

	cd -
}

function test_run()
{
	local subdir=$1
	shift 1
	local tests=( "$@" ) 

	local directory=${LIFERAY_PORTAL_DIR}/modules/apps/$subdir
	local no_settings_gradle=true

	do_test_run $directory $no_settings_gradle "${tests[@]}"
}

function test_run_dxp()
{
	local subdir=$1
	shift 1
	local tests=( "$@" ) 

	local directory=${LIFERAY_PORTAL_DIR}/modules/dxp/apps/$subdir
	local no_settings_gradle=true

	do_test_run $directory $no_settings_gradle "${tests[@]}"
}

function main() 
{

if [ "$RUN_ALL_TESTS" = true ]
then
	run_all_tests
else
	run_some_tests
fi

}


						main
