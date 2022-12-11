use async_trait::async_trait;
use serde_derive::{Deserialize, Serialize};
use std::sync::Arc;

pub type DynTheAction = Arc<dyn TheAction + Send + Sync>;

#[async_trait]
pub trait TheAction {
    async fn serve_resolved(&self, input: ActionInput) -> Result<ActionOutput, Error>;
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ActionInput {
    pub user_id: String,
    pub input_data: String,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ActionOutput {
    pub user_id: String,
    pub output_data: String,
}

#[derive(Debug)]
pub enum Error {
    Message(String),
}
