use axum::{extract::Extension, routing::post, Router};
use std::sync::Arc;

use crate::{handlers::action_handler, zoo::ReqCtx};

pub fn app_router(req_ctx: Arc<ReqCtx>) -> Router {
    Router::new()
        .route("/action/:user_id", post(action_handler))
        .layer(Extension(req_ctx))
}

#[cfg(test)]
mod tests {
    use super::*;
    use async_trait::async_trait;
    use axum::{
        body::Body,
        http::{self, Request},
    };
    use serde_json::json;
    use tokio::sync::Mutex;
    use tower::Service;

    use crate::zoo::IncomingPayload;
    use model::action_boundaries::{ActionInput, ActionOutput, Error, TheAction};

    #[derive(Default, Clone)]
    pub struct SpyTheActionState {
        pub input: Vec<ActionInput>,
    }

    pub struct SpyTheAction {
        pub state: Arc<Mutex<SpyTheActionState>>,
    }

    #[async_trait]
    impl TheAction for SpyTheAction {
        async fn serve_resolved(&self, input: ActionInput) -> Result<ActionOutput, Error> {
            let mut v = self.state.lock().await;
            v.input.push(input);

            Ok(ActionOutput::default())
        }
    }

    #[tokio::test]
    async fn handler_should_call_action() {
        let mock_state = Arc::new(Mutex::new(SpyTheActionState::default()));
        let mock: SpyTheAction = SpyTheAction {
            state: Arc::clone(&mock_state),
        };
        let req_ctx: Arc<ReqCtx> = Arc::new(ReqCtx {
            settings: Default::default(),
            action: Arc::new(mock),
        });

        let mut r = app_router(req_ctx);
        let target_url = format!("/action/{}", "USER_ID");
        let incoming_payload: IncomingPayload = IncomingPayload::default();

        let req = Request::builder()
            .method(http::Method::POST)
            .uri(target_url)
            .header(http::header::CONTENT_TYPE, mime::APPLICATION_JSON.as_ref())
            .body(Body::from(
                serde_json::to_vec(&json!(incoming_payload)).unwrap(),
            ))
            .unwrap();

        let _ = r.call(req).await.unwrap();

        let state_of_mock = mock_state.lock().await;

        assert_eq!(1, state_of_mock.input.len());
    }
}
