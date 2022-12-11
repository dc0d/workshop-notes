use model::action_boundaries::DynTheAction;

use serde::{Deserialize, Serialize};

#[derive(Default, Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct IncomingPayload {
    pub user_id: String,
    pub input_data: String,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct OutgoingPayload {
    pub user_id: String,
    pub output_data: String,
}

//

#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct QueryParams {
    #[serde(default = "default_val")]
    pub query_param: Option<String>,
}

fn default_val() -> Option<String> {
    Some(QUERY_PARAM_VAL.to_string())
}

pub const QUERY_PARAM_VAL: &str = "some_query_param";

//

#[derive(Clone)]
pub struct ReqCtx {
    pub action: DynTheAction,
    pub settings: Settings,
}

//

#[derive(Clone)]
pub struct Settings {
    pub some_url: String,
}

impl Default for Settings {
    fn default() -> Self {
        let some_url = std::env::var("SOME_URL").unwrap_or_else(|_| "https://example.com".into());

        Self { some_url }
    }
}
