context("assertions")

test_that("get_assert_method correctly choses assertion method", {
  fun_1 <- function() 1
  fun_2 <- function() 2
  method_raw <- data.validator:::get_assert_method(
    function(x) c(TRUE, FALSE), list(direct = fun_1, generator = fun_2)
  )
  method_gen <- data.validator:::get_assert_method(
    function(x) function(y) c(TRUE, FALSE), list(direct = fun_1, generator = fun_2)
  )
  expect_equal(method_raw, fun_1)
  expect_equal(method_gen, fun_2)
  expect_error(
    data.validator:::get_assert_method(function(x) c(1, 2), list(direct = fun_1, generator = fun_2))
  )
})

test_that("validate returns expected attributes", {
  data <- data.frame(V1 = c("c", "d"), V2 = c(2, 2), V3 = c(1, 1))
  data <- validate(data, description = "Validation object description test")
  attr_names <- names(attributes(data))

  expect_true("data-name" %in% attr_names)
  expect_true("data-description" %in% attr_names)
  expect_true("assertr_in_chain_success_fun_override" %in% attr_names)
  expect_true("assertr_in_chain_error_fun_override" %in% attr_names)
})

test_that("Validation works even with evaluation error", {
  validation_result <-
    data.validator::validate(iris, name = "Iris wrong column test") %>%
    validate_if(is.character(Speciies))

  expect_equal(nrow(validation_result), nrow(iris))
  expect_length(attr(validation_result, "assertr_errors"), 1)
})

test_that("validate_cols selects all columns if there are no columns selected", {
  data <- data.frame(V1 = c("c", "d"), V2 = c(2, 2), V3 = c(1, 1))

  result <- validate(data) %>%
    validate_cols(is.character)

  expect_equal(length(attr(result, which = "assertr_errors")), 2)
})

test_that("validate_cols throws a message if there are no columns selected", {
  data <- data.frame(V1 = c("c", "d"), V2 = c(2, 2), V3 = c(1, 1))

  validation <- validate(data)

  expect_message(validate_cols(validation, function(x) TRUE))
})

test_that("validate_rows selects all columns if there are no columns selected", {
  data <- data.frame(
    V1 = c(1, 0, 0),
    V2 = c(0, 0, 0),
    V3 = c(0, 1, 0)
  )

  is_lower_than_one <- function(x) {
    x < 1
  }

  result <- validate(data) %>%
    validate_rows(rowSums, is_lower_than_one)

  expect_equal(nrow(attr(result, "assertr_errors")[[1]]$error_df), 2)
})

test_that("validate_rows throws a message if there are no columns selected", {
  data <- data.frame(
    V1 = c(1, 0, 0),
    V2 = c(0, 0, 0),
    V3 = c(0, 1, 0)
  )

  validation <- validate(data)

  expect_message(validate_rows(validation, rowSums, function(x) TRUE))
})

test_that("validation returns assert_success or assert_errors attribute based on result", {
  name_success  <- "assertr_success"
  name_error  <- "assertr_errors"

  data <- data.frame(
    V1 = c(1, 0),
    V2 = c(-1, -2)
  )
  data <- validate(data)

  val_success <- validate_if(data, V2 < 0)
  val_error <- validate_if(data, V1 < 0)

  expect_true(name_success %in% names(attributes(val_success)))
  expect_false(name_error %in% names(attributes(val_success)))
  expect_true(name_error %in% names(attributes(val_error)))
  expect_false(name_success %in% names(attributes(val_error)))
})

describe("validate function identifies name attribute", {
  it("is identified when the function is called directly", {
    test_data <- data.frame(col_1 = c(0, 1, 2), col_2 = c(3, 4, 5))
    result <- attr(validate(test_data), "data-name")
    expect_equal(result, "test_data")
  })

  it("is identified with the native R pipe", {
    test_data <- data.frame(col_1 = c(0, 1, 2), col_2 = c(3, 4, 5))
    result <- test_data |> validate() |> attr("data-name")
    expect_equal(result, "test_data")
  })

  it("is identified with the magrittr pipe", {
    test_data <- data.frame(col_1 = c(0, 1, 2), col_2 = c(3, 4, 5))
    result <- test_data %>% validate() %>% attr("data-name")
    expect_equal(result, "test_data")
  })

  it("is preserved through a series of operations with pipes", {
    test_data <- data.frame(col_1 = c(0, 1, 2), col_2 = c(3, 4, 5))
    result_case_1 <- test_data |>
      dplyr::select(col_1) |>
      dplyr::filter(col_1 > 0) |>
      validate() |>
      attr("data-name")
    result_case_2 <- test_data %>%
      dplyr::select(col_1) %>%
      dplyr::filter(col_1 > 0) %>%
      validate() %>%
      attr("data-name")
    result_case_3 <- test_data |> dplyr::select(col_1) %>% validate() %>% attr("data-name")
    result_case_4 <- test_data %>% dplyr::select(col_1) |> validate() %>% attr("data-name")
    result_case_5 <- test_data %>% dplyr::select(col_1) %>% validate() |> attr("data-name")
    result_case_6 <- test_data |> dplyr::select(col_1) %>% validate() |> attr("data-name")

    expect_equal(result_case_1, "test_data")
    expect_equal(result_case_2, "test_data")
    expect_equal(result_case_3, "test_data")
    expect_equal(result_case_4, "test_data")
    expect_equal(result_case_5, "test_data")
    expect_equal(result_case_6, "test_data")
  })
})
