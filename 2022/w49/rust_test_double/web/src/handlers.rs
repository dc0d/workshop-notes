use axum::{
    extract::{Extension, Json},
    extract::{Path, Query},
    http::StatusCode,
    response::IntoResponse,
};
use hyper::HeaderMap;
use std::sync::Arc;

use crate::zoo::{IncomingPayload, OutgoingPayload, QueryParams, ReqCtx};
use model::action_boundaries::ActionInput;

pub async fn action_handler(
    Extension(req_ctx): Extension<Arc<ReqCtx>>,
    Path(_user_id): Path<String>,
    Query(_arams): Query<QueryParams>,
    Json(_incoming_payload): Json<IncomingPayload>,
    _headers: HeaderMap,
) -> impl IntoResponse {
    let _ = req_ctx.action.serve_resolved(ActionInput::default()).await;

    (StatusCode::OK, Json(OutgoingPayload::default()))
}
